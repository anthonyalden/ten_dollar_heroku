class Seller
  include Mongoid::Document
  field :username, type: String
  field :password_digest, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :phone, type: String
  field :email, type: String
  has_many :items
  validates_uniqueness_of :username
  attr_reader :password 

  validates :username, presence: true, length: {in: 6..20 }#, message: "User Name Must be Between 6 and 20 Character in Length and Must Have a Value Entered."
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
