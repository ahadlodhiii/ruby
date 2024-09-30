require 'mixpanel-ruby'

module Spree
  module Admin
    class VendorsController < ResourceController

      def create
        if permitted_resource_params[:image] && Spree.version.to_f >= 3.6
          @vendor.build_image(attachment: permitted_resource_params.delete(:image))
        end

        print("vendor create")
        print(permitted_resource_params)

        tracker = Mixpanel::Tracker.new(Rails.application.config.mixpanel_key)
        tracker.track(permitted_resource_params['name'], 'Signup on vendor side', {
            name: permitted_resource_params['name'],
            about_us: permitted_resource_params['about_us'],
            contact_us: permitted_resource_params['contact_us'],
            state: permitted_resource_params['state'],
            commission_rate: permitted_resource_params['commission_rate'],
            notification_email: permitted_resource_params['notification_email']
        })
        super
      end

      def update
        if permitted_resource_params[:image] && Spree.version.to_f >= 3.6
          @vendor.create_image(attachment: permitted_resource_params.delete(:image))
        end
        format_translations if defined? SpreeGlobalize
        super
      end

      def update_positions
        params[:positions].each do |id, position|
          vendor = Spree::Vendor.find(id)
          vendor.set_list_position(position)
        end

        respond_to do |format|
          format.js { render plain: 'Ok' }
        end
      end

      private

      def find_resource
        Vendor.with_deleted.friendly.find(params[:id])
      end

      def collection
        params[:q] = {} if params[:q].blank?
        vendors = super.order(priority: :asc)
        @search = vendors.ransack(params[:q])

        @collection = @search.result.
            page(params[:page]).
            per(params[:per_page])
      end

      def format_translations
        return if params[:vendor][:translations_attributes].blank?
        params[:vendor][:translations_attributes].each do |_, data|
          translation = @vendor.translations.find_or_create_by(locale: data[:locale])
          translation.name = data[:name]
          translation.about_us = data[:about_us]
          translation.contact_us = data[:contact_us]
          translation.slug = data[:slug]
          translation.save!
        end
      end
    end
  end
end
