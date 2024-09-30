# namespace :db do
#   desc 'Create the admin user'
#   task create_admin: :environment do
#     email = ENV['ADMIN_EMAIL'] || 'admin@example.com'
#     password = ENV['ADMIN_PASSWORD'] || 'password'
#     if Spree::User.find_by(email: email).nil?
#       admin = Spree::User.new(email: email, password: password, password_confirmation: password)
#       admin.spree_roles << Spree::Role.find_or_create_by(name: 'admin')
#       admin.save!
#       puts "Admin user created with email: #{email} and password: #{password}"
#     else
#       puts "Admin user with email: #{email} already exists."
#     end
#   end
# end
