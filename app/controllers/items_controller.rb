class ItemsController < ApplicationController


	

	def index

	      
		  if logged_in? == false
		  	@items = Item.where(:description => /.*#{params[:q]}.*/i)
		  	render "buyerindex"
		  else
		  	# @items = current_user.items.where(:description => /.*#{params[:q]}.*/i $or :item_tag => /.*#{params[:q]}.*/i)
		  	@items = current_user.items.where({ :$or => [ { :description => /.*#{params[:q]}.*/i }, { :item_tag => /.*#{params[:q]}.*/i } ] })
		  	render "index"
		  end
		
	end

	def show
		# retrieves ONE specific bean in our database
		# the parms refers to rails object with a key and object hash.  one of the hashes is an :id key.
		#       :id comes from the url specifically the part that has the id specified in the routes
		# Bean is our model
		# .find is method available to our Bean model it comes from mongoid gem
		@item = Item.find(params[:id])
	end

	def new
		# this makes a new one
		flash[:alert] = nil
		@item = Item.new
	end

	def create
		#the params object has some methods like .requre and .permit.  The permit says what attributes can be saved
		# :item is from the model
		# @item = item.new(params.require(:item).permit(:name, :roast, :origin, :quantity))
		#@item = Item.new (item_params)
		@item =current_user.items.new(item_params)
		
		if @item.save
		   flash[:alert] = nil
		   redirect_to items_path
		else
			flash[:alert] = "Item price must be $10 or less.  Please enter a new price."
			render "new"
		end
		
		
			# if not successful go back to new page to reenter the data again
			
	end

	def edit
		# action for retrieving a specific been
		# this is the same code you use for the show action
		flash[:notice] = nil
		@item = Item.find(params[:id])
		@seller = Seller.new.username

	end

	def update
		# this retrieves a specific item from database
		@item = Item.find(params[:id])
		if @item.update_attributes(item_params)
		   flash[:notice] = nil
		   redirect_to items_path
		else
			flash[:notice] = "Item price must be $10 or less.  Please enter a new price."
			render "edit"
		end
		
	end

	def destroy
		@item = Item.find(params[:id])
		@item.destroy
		redirect_to items_path
	end


private
# anyting in this private area 
	def item_params
		params.require(:item).permit(:price, :item_tag, :description, :photo, :category, :search_tags, :shipping_cost, :sold, :seller, :username, :image)
	end

end