class ItemsController < ApplicationController


	

	def index

	      # condtionally render buyers page or sellers page depending if 
	      # 	seller is logged in index is seller page buyers index is buyers page
		  if logged_in? == false
		  	@items = Item.where({ :$or => [ { :description => /.*#{params[:q]}.*/i }, { :item_tag => /.*#{params[:q]}.*/i } ] })
		  	render "buyerindex"
		  else
		  	@items = current_user.items.where({ :$or => [ { :description => /.*#{params[:q]}.*/i }, { :item_tag => /.*#{params[:q]}.*/i } ] })
		  	render "index"
		  end
		
	end

	def show
		@item = Item.find(params[:id])
	end

	def new
		# set flash message to disappear if it was displayed earlier
		flash[:alert] = nil
		@item = Item.new
	end

	def create
		
		@item =current_user.items.new(item_params)
		
		if @item.save
			# display item index page for seller after new items is created
		   redirect_to items_path
		else
			render "new"
		end
			
	end

	def edit
		# reset flash notice to not display from pervious display of notice
		flash[:notice] = nil
		@item = Item.find(params[:id])
		@seller = Seller.new.username

	end

	def update
		
		@item = Item.find(params[:id])
		if @item.update_attributes(item_params)
			# display item index page for seller after existing item is updated
		   redirect_to items_path
		else
			render "edit"
		end
		
	end

	def destroy
		@item = Item.find(params[:id])
		@item.destroy
		# display item index page for seller after item is deleted
		redirect_to items_path
	end


private
 
	def item_params
		params.require(:item).permit(:price, :item_tag, :description, :photo, :category, :search_tags, :shipping_cost, :sold, :seller, :username, :image)
	end

end