class StripeController < ActionController::Base
  def connect_callback_receiver

    begin
      response = Stripe::OAuth.token({
                                       grant_type: 'authorization_code',
                                       code: params[:code],
                                     })

      encrypted_vendor_id = params[:state].split(":").last
      # vendor = Spree::Vendor.where(id: Encryptor.decrypt(encrypted_vendor_id)).last
      vendor = Spree::Vendor.where(id: encrypted_vendor_id).last

      if vendor.present?

        vendor.stripe_user_id = response.stripe_user_id
        vendor.stripe_access_token = response.access_token
        vendor.stripe_refresh_token = response.refresh_token
        vendor.stripe_publishable_key = response.stripe_publishable_key
        vendor.save!(validate: false)
        flash[:notice] = "You have successfully linked your stripe account"
      end
    rescue
      flash[:error] = "Failed to connect, please contact support"
    end

    redirect_to spree.admin_vendor_settings_path
  end
end