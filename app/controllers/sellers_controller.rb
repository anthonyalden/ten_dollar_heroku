class SellersController < ApplicationController
	def index
		@sellers =Seller.all
		
	end

	def show
		
		@seller = Seller.find(params[:id])
	end

	def new
		# cuases flash message to turn off from prior display
		flash[:notice] = nil
		@seller = Seller.new
	end

	def create
		
				@seller = Seller.new (seller_params)
				# downcase username so all usernames are stored lowercase
				# later on when username is entered to login it is also downcased
				# this lets a user enter upper and lower case usernames and makes
				# the username not case sensitive
				@seller.username = @seller.username.downcase
				if @seller.save 
					
					# reset flash notice if it was displayed earlier
					flash[:notice] = nil
					session[:user_id] = @seller.id.to_s
					# display sellers item index page after new user is created
					#  logged in.
					redirect_to items_path
				else
					render "new"
				end
	end

	def edit
		# reset flash notice if it was displayed earlier
		flash[:notice] = nil
		@seller = Seller.find(params[:id])

	end

	def update
	
		@seller = Seller.find(params[:id])
		# downcase username when edited so it is stored in lowercase
		#   this makes the username case insensitve
		@seller.username = @seller.username.downcase
		if @seller.update_attributes(seller_params)
			# return to the sellers item index page after update to user info
			redirect_to items_path
		else
			render "edit"
		end
	end

	def destroy
		@seller = Seller.find(params[:id])
		# find all existing items user created and delete them as part of
		#    deleting the user
		@items = Item.where(:seller_id => current_user)
		@items.destroy
		# cancel the session for the user
		session.delete(:user_id)
		@seller.destroy
		# display the user buyerindex page after the user is deleted
		redirect_to items_path
	end


private

	def seller_params
		params.require(:seller).permit(:username, :password, :first_name, :last_name, :phone, :email, :password)
	end

end