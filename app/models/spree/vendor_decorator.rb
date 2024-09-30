module Spree::VendorDecorator
  def self.prepended(base)
    base.has_one :address
    base.has_many :zones
    base.has_many :stripe_transfers, class_name: "::StripeTransfer", foreign_key: 'spree_vendor_id'
  end

  def commission_rate
    1 - super
  end

  def is_stripe_connected?
    self.stripe_user_id.present?
  end
end

Spree::Vendor.prepend Spree::VendorDecorator