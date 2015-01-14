module SessionsHelper

	# returns the current seller user from a given login session
	# used througout to when a user is required as a parameter or object
	def current_user
		
				@current_user ||= Seller.find(session[:user_id])
	end

	# used as a flag throughout to let the system know if a seller is logged in so 
	# that pages can be customize to either a buyer or seller.  If logged_in is true
	# this means that the seller is logged in and the system should display seller
	# thoses things relevent to a seller and not a buyer
	def logged_in?
		
		session[:user_id] != nil
	end

end
