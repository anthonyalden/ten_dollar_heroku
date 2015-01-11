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

  
  def password=(unencrypted_password)

	self.password_digest = BCrypt::Password.create(unencrypted_password)

  end

  def authenticate(unencrypted_password)
  		if BCrypt::Password.new(self.password_digest) == unencrypted_password
  			return self
  		else
  			return false
  		end
  end

end
