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
end
