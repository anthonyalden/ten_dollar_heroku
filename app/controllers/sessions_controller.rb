class SessionsController < ApplicationController
	def new

	end

	def create 
		# creates a new login session

		#  downcase the username search because it is stored lower case only thus
		#   the username is case insensitve
		seller = Seller.where(username: params[:login][:username].downcase).first
		if seller && seller.authenticate(params[:login][:password])
			session[:user_id] = seller.id.to_s 
			redirect_to seller_path(seller.id) 
		else 
			# if username or password is invalid display this message
			flash[:notice] = "Invalid Username/Password"
			redirect_to items_path

		end
	end

	def destroy
		# end a login session
		session.delete(:user_id) 
		redirect_to items_path
	end
end
