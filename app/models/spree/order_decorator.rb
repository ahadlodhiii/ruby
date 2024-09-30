module Spree
  module OrderDecorator
    def self.prepended(base)
      base.has_one :address
      # base.state_machine.after_transition to: :complete, do: :transfer_payments
    end

    def vendor_list
      @vendor_list ||= self.line_items.map{|li|li.product.vendor}.uniq.compact
    end

    def transfer_payments
      payment = self.payments.completed.last

      return unless payment
      vendor_list.each do |vendor|
        next unless vendor.is_stripe_connected?
        parent_payment = self.payments.completed.last

        transfer_group = Spree::Payment::GatewayOptions.new(parent_payment).order_id
        transfer_amount = ((self.vendor_total(vendor) - self.vendor_commission(vendor)) * 100).to_i # convert to cents
        
        begin
          transfer = Stripe::Transfer.create({
                                               amount: transfer_amount, # cents, hardcoded for now
                                               currency: payment.currency.downcase,
                                               destination: vendor.stripe_user_id,
                                               transfer_group: transfer_group,
                                               source_transaction: payment.stripe_charge_id,
                                             })

          StripeTransfer.create!(
            external_id: transfer.id,
            destination: transfer.destination,
            destination_payment: transfer.destination_payment,
            amount: transfer.amount,
            currency: transfer.currency,
            transfer_group: transfer_group,
            payment_id: parent_payment.id,
            spree_vendor_id: vendor.id
          )
          parent_payment.stripe_transfer = true
          parent_payment.save
        rescue StandardError => e
        end

      end
    end
  end
end

::Spree::Order.prepend ::Spree::OrderDecorator