class Product < ApplicationRecord
  include Searchable
  include SoftDeletable

  serialize :boxes, ProductBox

  validates :name, :retail_price, :half_wholesale_price,
    :wholesale_price, :required_units_half_wholesale,
    :required_units_wholesale, presence: true

  validates :retail_price, numericality: true
  validates :half_wholesale_price, numericality: { greater_than_or_equal_to: :retail_price }
  validates :wholesale_price, numericality: { greater_than_or_equal_to: :half_wholesale_price }

  validates :required_units_half_wholesale, 
    numericality: { only_integer: true, greater_than: 0 }
  validates :required_units_wholesale, 
    numericality: { only_integer: true, greater_than: :required_units_half_wholesale}
  
  scope :recent, -> { order(created_at: :desc) }
  scope :order_by_name, -> (way = :asc) {
    order(name: way)
  }
  scope :order_by_price, -> (way = :asc) {
    order(retail_price: way)
  }

  def to_s
    name
  end

  def to_param
    "#{id}-#{name}"
  end
end
