class Item
  include Mongoid::Document
  field :price, type: Float
  field :item_tag, type: String
  field :description, type: String
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
end
