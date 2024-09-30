class ApplicationController < ActionController::Base
  before_action :load_static_footer_pages
  before_action -> { set_noindex_header if Rails.env.production? }

  def load_static_footer_pages
    @static_footer_pages = Spree::Page.by_store(current_store).visible.footer_links
  end

  def set_noindex_header
    response.headers['X-Robots-Tag'] = 'noindex, nofollow'
  end    
end
