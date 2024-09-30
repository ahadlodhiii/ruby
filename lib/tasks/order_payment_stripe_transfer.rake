desc "This task run stripe connect amount"
task :transfer_payment_stripe => :environment do
  payments_not_transfered = Spree::Payment.before_15_days_payments.stripe_payments.completed.not_transfer_to_stripe
  if payments_not_transfered.present?
    puts "transfer payment is process #{payments_not_transfered.count} "
    payments_not_transfered.each do |pending_payment|
      pending_payment.order.transfer_payments
    end
    puts "transfer done."
  else
    puts "no any transfer payments present"
  end
end
