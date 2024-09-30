module Spree
  module Calculator::Shipping
    class MyOwnCalculator < Spree::ShippingCalculator
      preference :first_day,      :decimal, default: 0.0
      preference :next_day, :decimal, default: 0.0
      preference :currency,        :string,  default: -> { Spree::Config[:currency] }
      def self.description
        Spree.t("Stg Own Shipping")
      end

      def compute_package(package)
        # self.preferred_amount
        now = Time.now.utc - 5.hour
        price = 0
        if now.hour < 19 || (now.min < 30 && now.hour == 19)
          price = preferred_first_day
        else
          price = preferred_next_day
        end
        price * package.quantity
      end

      def self.available?(_object)
        true
      end

    end
  end
end

