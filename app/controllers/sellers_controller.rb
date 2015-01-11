class SellersController < ApplicationController
	def index
		# retrieves ALL the beans in our database
		@sellers =Seller.all
		
	end

	def show
		# retrieves ONE specific seller in our database
		# the parms refers to rails object with a key and object hash.  one of the hashes is an :id key.
		#       :id comes from the url specifically the part that has the id specified in the routes
		# Seller is our model
		# .find is method available to our Seller model it comes from mongoid gem
		@seller = Seller.find(params[:id])
	end

	def new
		# this makes a new one
		flash[:notice] = nil
		@seller = Seller.new
	end

	def create
		#the params object has some methods like .requre and .permit.  The permit says what attributes can be saved
		# :seller is from the model
				@seller = Seller.new (seller_params)
				if @seller.save 
					# if save is ok go back to index.html
					flash[:notice] = nil
					redirect_to sellers_path
				else
					# if not successful go back to new page to reenter the data again
					flash[:notice] = "This User Name is already used by someone else.  Please choose another User Name."
					render "new"
				end
	end

	def edit
		# action for retrieving a specific Seller
		# this is the same code you use for the show action
		flash[:notice] = nil
		@seller = Seller.find(params[:id])

	end

	def update
		# this retrieves a specific seller from database
		@seller = Seller.find(params[:id])

		if @seller.update_attributes(seller_params)
			redirect_to sellers_path
		else
			flash[:notice] = "This User Name is already used by someone else.  Please choose another User Name."
			render "edit"
		end
	end

	def destroy
		@seller = Seller.find(params[:id])
		@items = Item.where(:seller_id => current_user)
		@items.destroy
		session.delete(:user_id)
		@seller.destroy
		redirect_to items_path
	end


private
# anyting in this private area is only visible to this class
	def seller_params
		params.require(:seller).permit(:username, :password, :first_name, :last_name, :phone, :email, :password)
	end

end