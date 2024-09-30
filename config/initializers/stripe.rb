Rails.configuration.stripe = {
  :publishable_key => Rails.application.secrets.stripe[:publishable_key],
  :secret_key      => Rails.application.secrets.stripe[:secret_key],
  :client_id => Rails.application.secrets.stripe[:client_id],
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
Stripe.api_version = "2018-05-21"
Stripe.client_id = Rails.configuration.stripe[:client_id]
