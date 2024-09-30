require 'mixpanel-ruby'
$tracker = Mixpanel::Tracker.new('d792e31ec8b45ef59c396ff5f97def89')

if Rails.env.development? 
  #silence local SSL errors
  Mixpanel.config_http do |http|
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  end
end