module Spree
	class HomeController < Spree::StoreController
		after_action :landing_page_loaded, only: :index
		before_action :set_show_header, only: [:men, :women, :index]
		def newSubscriber
			respond_to do |format|
				emails = params[:subscriber_email]
				format.html { render :index, locals: { status_msg: 'Yes form submit' } }
			end	
		end
		def landing_page_loaded
			user = spree_current_user.present? ? spree_current_user.email : "Guest User"
			data = spree_current_user.present? ? {current_user_email: spree_current_user.email} : {}
			TriggerMixpanelEvent.perform_now(user, 'Landing page loaded', data )
		end

		def set_show_header
			@show_header = params[:action] == 'index'  ? true : false
		end
	end
end
