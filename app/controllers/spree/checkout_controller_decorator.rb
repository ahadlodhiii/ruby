module Spree
  module CheckoutControllerDecorator
    def self.prepended(base)
      base.after_action :track_events, only: [:edit, :update]
    end
    def track_events
      event_name = "Checkout"
      data = {}
      delivery_method = request.url.include? "/update/delivery"
      payments_method = request.url.include? "/update/payment"
      checkout        = request.url.include? "/checkout/address"
      if delivery_method

        data[:selected_shipping_rate_id] = params[:order]["shipments_attributes"]["0"]["selected_shipping_rate_id"]
        data[:shipment_cost] = Spree::ShippingRate.find_by_id(data[:selected_shipping_rate_id]).display_cost
        event_name = "Delivery method added"

      end
      if payments_method

        data[:payment_method_id] = params[:order][:payments_attributes][0]["payment_method_id"]
        data[:amount] = params[:order][:payments_attributes][0]["amount"]
        event_name = "Payment method"

      end
      if checkout || payments_method || delivery_method
        trigger_mixpanel_event(event_name, data)
      end
    end

    def trigger_mixpanel_event(event_name, data)
      user = spree_current_user.present? ? spree_current_user.email : "Guest User"
      TriggerMixpanelEvent.perform_now(user, event_name, data )
    end
  end
end
::Spree::CheckoutController.prepend Spree::CheckoutControllerDecorator
