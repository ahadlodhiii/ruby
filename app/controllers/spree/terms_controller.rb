module Spree
  class TermsController < Spree::StoreController
    include Spree::FrontendHelper

    respond_to :html

    def index
      render template: 'spree/home/terms', layout: true
    end

    def policy
      render template: 'spree/home/privacy_policy', layout: true
    end

    def refund
      render template: 'spree/home/refund_policy', layout: true
    end
  end
end

