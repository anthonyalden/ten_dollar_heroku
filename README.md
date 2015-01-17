== README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies 
Mongoid - Databse, 

Figaro - used to manage ENV variables for use on Amazon  S3 so that the keys are not uploaded, 

bcrypt - used to encrypt passwords, 

Carrierwave - used to used to upload image files to the application and store them on Amazon S3., 

fog is used for Amazon S3.

mini_magick is used for upload processing.

rails_12factor - used to server the assets including the CSS to render correctly on Heroku.

* Configuration
Amazon S3 keys must be entered in the application yml file.  These keys include the key, secret key, bucket name, and region all supplied by Amazon.  Git ignore MUST include application.yml in order for keys not to be made public when uploads to heroku or github are made.  You must the storage to fog in the /uploaders/avatar_uploader.rb file when running on Amazon S3 (will also work when running locally).
No other configuration is necessary to run this application.

* Database creation
Database is automatically created and configured when writes to are made the first time that the program is run.

* Database initialization
None required
* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)
None
* Deployment instructions
None required.

* Purpose
Ten Dollar Store is a sales platform for users(buyers) to find products for sale that are sold at a price of $10 and under.  There is no limit for shipping cost.  If a seller trys to enter a sales price greater than $10, an error message will be displayed that this is not allowed.  Buyers are not required to have an account to view the items for sale.  Currently, the application only lists items for sale.  Future expansion will allow adding the items for sale to a shopping cart and paying for the items.  The site as it stands now is a concept demonstration for the listing and searching for item for sale.

Sellers must create an account to list thier items for sale.  This is done by clicking on the "crate account" menu option.  Information for an item for sale includes: Item tag (the item for sale such as CAMERA), a description, cost of the item, and shipping cost and a photo can be uploaded.  Account information for the seller includes: username (used for login), password, first name, last name, phone number and email.  Account information can be edited and deleted.  Deleting an account deletes all items and photos from the database and those stored on Amazon S3.

Searhing for items will return results by searching both the item_tag field and the description field.  Search terms can be whole or partial words.  The more complete the search string is for an item, the more accurately the search will return only those desired items.

When a seller is logged in, only those items for sale owned by the seller will display.  To display all items by other sellers the user must logout and search as a buyer.  A seller can only edit his own items. Items can be created, editied and deleted.  The system displays an item list summary by clicking on items for sale menu option on the menu bar.  By clicking on the display all items for sale menu option on the menu bar, items are listed with complete inforamtion including a photo.  By clicking on an item, a larger photo is displayed and all fields are displayed.  This is also true for buyers using the system. 

* Amazon S3
Amazon S3 is used to store photos that are uploaded for items that are for sale.  Carrierwave is used to do the acutal uploading management.  Must set the avatar_uploader variable storage to fog.  Amazon key, secret key, bucket, and region must be entered in the application.yml file and application.yml must be entered into gitignore to protect the keys from being uploaded to heroku or github; not doing this would compromise the security of the keys and would make them public.

* Models:
*** item model: attributes:
	class Item
		  include Mongoid::Document
		  field :price, type: Float
		  field :item_tag, type: String
		  field :description, type: String
		  field :category, type: String
		  field :search_tags, type: String
		  field :shipping_cost, type: Float
		  field :sold, type: Mongoid::Boolean
		  validates_numericality_of :price, less_than_or_equal_to: 10.00, message: "Item Price Must be $10 or Less"
		  belongs_to :seller
		  mount_uploader :image, AvatarUploader

		  validates :price, presence: true
		  validates :item_tag, presence: true#. message: "Item Must Vave a Value Entered."
		  validates :description, presence: true#, message: "Description Must Have a Value Entered."
		  validates_numericality_of :shipping_cost, greater_than: 0#, message: "Shipping Cost Must be Larger than Zero Dollars"
		  validates :shipping_cost, presence: true
	  The item model includes the validations listed above, which will genereate error messages displayed by reference to the error message method to the screen as a list.  See code in the view files: _form_html.erb for both users and items.

	  mount_uploader uses the AvatarUploader to handle images that are saved to Amazon S3.

	  Items are related to sellers by in a many to one relationship (A seller many have many items for sale, but an item is for sales by only one seller).


***seller model
	class Seller
		  include Mongoid::Document
		  field :username, type: String
		  field :password_digest, type: String
		  field :first_name, type: String
		  field :last_name, type: String
		  field :phone, type: String
		  field :email, type: String
		  has_many :items
		  # validates_uniqueness_of :username  case_sensitive: false
		  attr_reader :password 

		  validates :username, presence: true, uniqueness:  {case_sensitive: false}, length: {in: 6..20 }#, message: "User Name Must be Between 6 and 20 Character in Length and Must Have a Value Entered."
		  validates :password, presence: true, length: {in: 6..20 }#, message: "Password Must be Between 6 and 20 Character in Length and Must Have a Value Entered."
		  validates :first_name, presence: true#, message: "First Name Must Have a Value Entered."
		  validates :last_name, presence: true#, message: "Last Name Must Have a Value Entered."
		  validates :email, presence: true , format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
		  validates :phone, presence: true, format: {with: /\(?([0-9]{3})\)?[-]?([0-9]{3})[-]?([0-9]{4})/}#,message: "Phone Must Have a Value Entered in the Format 999-999-9999."
		  

		  def password=(unencrypted_password)
		    unless unencrypted_password.empty?
		      @password = unencrypted_password
			    self.password_digest = BCrypt::Password.create(unencrypted_password)
		    end
		  end

		  def authenticate(unencrypted_password)
		  		if BCrypt::Password.new(self.password_digest) == unencrypted_password
		  			return self
		  		else
		  			return false
		  		end
		  end

		end
	validation is done in the model as listed above.  Email validation included making sure that the format of a valid email address is enforced.

	** methods:
		Password handles encryption of password and the result of an encrypted password is store in the database in the field password_digest.

		Authenticate is used to verify that a password is valid for the given user by comparing an uncryped password to the encrypted password (the encrypted password is decrypted prior to the comparison).

* Controllers:
There are three controllers: Items, Sellers, and Sessions.  The sessions controller is used to manage the creation and delettion of the login of sellers.  See those files for comments that describe how index, new, create, edit, update, and destroy work.

*** routes:

			Prefix Verb   URI Pattern                 Controller#Action
		       root GET    /                           items#index
		    sellers GET    /sellers(.:format)          sellers#index
		            POST   /sellers(.:format)          sellers#create
		 new_seller GET    /sellers/new(.:format)      sellers#new
		edit_seller GET    /sellers/:id/edit(.:format) sellers#edit
		     seller GET    /sellers/:id(.:format)      sellers#show
		            PATCH  /sellers/:id(.:format)      sellers#update
		            PUT    /sellers/:id(.:format)      sellers#update
		            DELETE /sellers/:id(.:format)      sellers#destroy
		      items GET    /items(.:format)            items#index
		            POST   /items(.:format)            items#create
		   new_item GET    /items/new(.:format)        items#new
		  edit_item GET    /items/:id/edit(.:format)   items#edit
		       item GET    /items/:id(.:format)        items#show
		            PATCH  /items/:id(.:format)        items#update
		            PUT    /items/:id(.:format)        items#update
		            DELETE /items/:id(.:format)        items#destroy
		      login POST   /login(.:format)            sessions#create
		     logout DELETE /logout(.:format)           sessions#destroy

* Views:
*** items:
	_form.html.rb - contains the form for new and edit views
	edit contains the html for editing an item and deleting an item
	new  contains the html for entering a new item
	index contains the html for displaying seller view of all items for sale.  Buyersindex contains html for displaying buyer view of all items for sale
		including displaying the login boxes, that are not displayed for sellers.
	show - contains html to display the informatin for a single item.

*** sellers:
	_form contails the form for new and edit views
	edit contains the html for ediging a seller and deleting a seller
	new contains the html for entering a new seller
	index is not used in this application as it would list ALL sellers and
		this application doesn't show all sellers to sellers or buyers
	show contains the html to display the inforamtion of the currently logged in
		seller, specifically it show all items that are for sale by the seller.






Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.


