module Spree::PaymentDecorator

	def self.prepended(base)
		base.has_many :stripe_transfers, class_name: '::StripeTransfer', foreign_key: :payment_id
		base.scope :stripe_payments, -> {where.not(stripe_charge_id: nil)}
		base.scope :not_transfer_to_stripe, -> {where(stripe_transfer: false)}
		base.scope :before_15_days_payments, -> {where('created_at <= ?', Time.now-14.days)}
	end

	def handle_response(response, success_state, failure_state)
		if response.success? && response.respond_to?(:params)
			puts "Planteka::PaymentDecorator#handle_response"
			puts response.params

			self.intent_client_key = response.params["client_secret"] if response.params["client_secret"]

			charge = if response.params["object"] == "payment_intent"
						response.params.dig("charges", "data")&.first
					elsif response.params["object"] == "charge"
						response.params
					end
			puts charge
			self.stripe_charge_id = charge&.dig("id")
		end
		super
	end

end

::Spree::Payment.prepend ::Spree::PaymentDecorator