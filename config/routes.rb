require 'sidekiq/web'
Rails.application.routes.draw do
  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to
  # Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the
  # :at option to something different.
  mount Sidekiq::Web => "/sidekiq"
  

  get '/men' => 'spree/home#men', as: 'show_men_home'
  get '/women' => 'spree/home#women', as: 'show_women_home'
  get 'stripe/connect_callback_receiver'
  # We ask that you don't use the :as option here, as Spree relies on it being
  # the default of "spree".
  mount Spree::Core::Engine, at: '/'


  


  
  # match '*path' => redirect('/'), via: :get
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

Spree::Core::Engine.add_routes do
  get '/products/:id/vendor', to: 'products#vendor'
  get '/terms', to: 'terms#index'
  get '/privacy_policy', to: 'terms#policy'
  get '/refund_policy', to: 'terms#refund'

  namespace :admin do
    get 'vendor_stripe_disconnect' => 'vendor_settings#disconnect_stripe'
  end
end

