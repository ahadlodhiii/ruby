Spree::TaxonsController.class_eval do
  after_action :track_events, only: [:show]

  def show
    if stale?(etag: etag, last_modified: last_modified, public: true)
      load_products
    end
  end
  def track_events
    data = {Taxon: params[:id]}
    user = spree_current_user.present? ? spree_current_user.email : "Guest User"
    TriggerMixpanelEvent.perform_now(user, 'Category Clicked', data )
  end
end
