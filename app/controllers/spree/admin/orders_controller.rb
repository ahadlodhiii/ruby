module Spree
  module Admin
    class OrdersController < Spree::Admin::BaseController
      before_action :initialize_order_events
      before_action :load_order, only: [:edit, :update, :cancel, :resume, :approve, :resend, :open_adjustments, :close_adjustments, :cart, :store, :set_store]

      respond_to :html

      def index
        params[:q] ||= {}
        params[:q][:completed_at_not_null] ||= '1' if Spree::Config[:show_only_complete_orders_by_default]
        @show_only_completed = params[:q][:completed_at_not_null] == '1'
        params[:q][:s] ||= @show_only_completed ? 'completed_at desc' : 'created_at desc'
        params[:q][:completed_at_not_null] = '' unless @show_only_completed

        # As date params are deleted if @show_only_completed, store
        # the original date so we can restore them into the params
        # after the search
        created_at_gt = params[:q][:created_at_gt]
        created_at_lt = params[:q][:created_at_lt]

        params[:q].delete(:inventory_units_shipment_id_null) if params[:q][:inventory_units_shipment_id_null] == '0'

        if params[:q][:created_at_gt].present?
          params[:q][:created_at_gt] = begin
            Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day
          rescue StandardError
            ''
          end
        end

        if params[:q][:created_at_lt].present?
          params[:q][:created_at_lt] = begin
            Time.zone.parse(params[:q][:created_at_lt]).end_of_day
          rescue StandardError
            ''
          end
        end

        if @show_only_completed
          params[:q][:completed_at_gt] = params[:q].delete(:created_at_gt)
          params[:q][:completed_at_lt] = params[:q].delete(:created_at_lt)
        end

        @search = Spree::Order.preload(:user).accessible_by(current_ability, :index).ransack(params[:q])

        # lazy loading other models here (via includes) may result in an invalid query
        # e.g. SELECT  DISTINCT DISTINCT "spree_orders".id, "spree_orders"."created_at" AS alias_0 FROM "spree_orders"
        # see https://github.com/spree/spree/pull/3919
        @orders = @search.result(distinct: true).
            page(params[:page]).
            per(params[:per_page] || Spree::Config[:admin_orders_per_page])

        # Restore dates
        params[:q][:created_at_gt] = created_at_gt
        params[:q][:created_at_lt] = created_at_lt
      end

      def new
        @order = Spree::Order.create(order_params)
        redirect_to cart_admin_order_url(@order)
      end

      def edit
        can_not_transition_without_customer_info

        @order.refresh_shipment_rates(ShippingMethod::DISPLAY_ON_BACK_END) unless @order.completed?
      end

      def cart
        @order.refresh_shipment_rates(ShippingMethod::DISPLAY_ON_BACK_END) unless @order.completed?

        if @order.shipments.shipped.exists?
          redirect_to edit_admin_order_url(@order)
        end
      end

      def store
        @stores = Spree::Store.all
      end

      def update
        if @order.update(params[:order]) && @order.line_items.present?
          @order.update_with_updater!
          unless @order.completed?
            # Jump to next step if order is not completed.
            redirect_to admin_order_customer_path(@order) and return
          end
        else
          @order.errors.add(:line_items, Spree.t('errors.messages.blank')) if @order.line_items.empty?
        end

        render action: :edit
      end

      def cancel
        @order.canceled_by(try_spree_current_user)
        flash[:success] = Spree.t(:order_canceled)
        redirect_back fallback_location: spree.edit_admin_order_url(@order)
      end

      def resume
        @order.resume!
        flash[:success] = Spree.t(:order_resumed)
        redirect_back fallback_location: spree.edit_admin_order_url(@order)
      end

      def approve
        @order.approved_by(try_spree_current_user)

        begin
          vendor_lineitems = {}
          @order.line_items.each do |line_item|
            unless vendor_lineitems[line_item.variant.product.vendor.id]
              vendor_lineitems[line_item.variant.product.vendor.id] = []
            end
            vendor_lineitems[line_item.variant.product.vendor.id].push(line_item)
          end

          contact_description = "Please call customer service if you have any problem.\nPhone Number: (305)915-1557"
          vendor_lineitems.keys.each do |vendor_key|
            vendor = Spree::VendorUser.find_by(vendor_id: vendor_key)
            lineitems = vendor_lineitems[vendor_key]
            vendor_address = vendor.user.addresses[0]
            product_description = ""
            lineitems.each do |lineitem|
              product_description += "----------------\n"
              product_description += "Product Name: " + lineitem.variant.product.name + "\n"
              product_description += "Quantity: " + lineitem.quantity.to_s + "\n"
              product_description += lineitem.options_text + "\n"
              product_description += "----------------\n"
              product_description += "\n"
            end
            pickup_task = Onfleet::Task.create(
                destination: {
                    address: {
                        unparsed: vendor_address.address1
                    }
                },
                recipients:
                    [{
                         name: vendor_address.firstname + " " + vendor_address.lastname,
                         phone: vendor_address.phone,
                     }],
                pickup_task: true,
                notes: "Pickup these products from recipients\n" + product_description + "\n" + contact_description
            )
            customer_address = @order.bill_address

            dropoff_task = Onfleet::Task.create(
                destination: {
                    address: {
                        unparsed: customer_address.address1
                    }
                },
                recipients:
                    [{
                         name: customer_address.firstname + " " + customer_address.lastname,
                         phone: customer_address.phone
                     }],
                pickup_task: false,
                dependencies: [pickup_task.id],
                notes: "Drop off these products\n" + product_description + "\n" + contact_description
            )
          end
        rescue Exception
# ignored
        end
        flash[:success] = Spree.t(:order_approved)
        redirect_back fallback_location: spree.edit_admin_order_url(@order)
      end

      def resend
        OrderMailer.confirm_email(@order.id, true).deliver_later
        flash[:success] = Spree.t(:order_email_resent)

        redirect_back fallback_location: spree.edit_admin_order_url(@order)
      end

      def open_adjustments
        adjustments = @order.all_adjustments.finalized
        adjustments.update_all(state: 'open')
        flash[:success] = Spree.t(:all_adjustments_opened)

        respond_with(@order) { |format| format.html { redirect_back fallback_location: spree.admin_order_adjustments_url(@order) } }
      end

      def close_adjustments
        adjustments = @order.all_adjustments.not_finalized
        adjustments.update_all(state: 'closed')
        flash[:success] = Spree.t(:all_adjustments_closed)

        respond_with(@order) { |format| format.html { redirect_back fallback_location: spree.admin_order_adjustments_url(@order) } }
      end

      def set_store
        if @order.update(store_id: params[:order][:store_id])
          flash[:success] = flash_message_for(@order, :successfully_updated)
        else
          flash[:error] = @order.errors.full_messages.join(', ')
        end

        redirect_to store_admin_order_url(@order)
      end

      private

      def order_params
        params[:created_by_id] = try_spree_current_user.try(:id)
        params.permit(:created_by_id, :user_id, :store_id)
      end

      def load_order
        @order = Spree::Order.includes(:adjustments).find_by!(number: params[:id])
        authorize! action, @order
      end

      # Used for extensions which need to provide their own custom event links on the order details view.
      def initialize_order_events
        @order_events = %w{approve cancel resume}
      end

      def model_class
        Spree::Order
      end
    end
  end
end
