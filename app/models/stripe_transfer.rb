class StripeTransfer < ApplicationRecord
  belongs_to :payment, class_name: 'Spree::Payment'
  belongs_to :vendor, class_name: 'Spree::Vendor', foreign_key: 'spree_vendor_id'
end
