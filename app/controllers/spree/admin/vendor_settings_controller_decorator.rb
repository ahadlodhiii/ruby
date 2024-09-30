module Spree::Admin::VendorSettingsControllerDecorator
  def disconnect_stripe
    vendor = @vendor
    vendor.stripe_user_id = ''
    vendor.stripe_access_token = ''
    vendor.stripe_refresh_token = ''
    vendor.stripe_publishable_key = ''
    vendor.save!(validate: false)

    flash[:success] = "Successfully Disconnected"
    redirect_to spree.admin_vendor_settings_path
  end
end

Spree::Admin::VendorSettingsController.prepend Spree::Admin::VendorSettingsControllerDecorator