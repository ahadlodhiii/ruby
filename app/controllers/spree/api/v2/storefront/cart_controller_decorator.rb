Spree::Api::V2::Storefront::CartController.class_eval do
  def add_item
    spree_authorize! :update, spree_current_order, order_token
    spree_authorize! :show, @variant

    result = add_item_service.call(
      order: spree_current_order,
      variant: @variant,
      quantity: params[:quantity],
      options: params[:options]
    )

    render_order(result)
    data = { variant_sku: @variant.sku, quantity: params[:quantity]}

    user = spree_current_user.present? ? spree_current_user.email : "Guest User"
    TriggerMixpanelEvent.perform_now(user, 'Add to Cart', data )
  end
end

