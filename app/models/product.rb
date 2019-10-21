class Product < ApplicationRecord
  include Searchable
  include SoftDeletable
  
  has_one_attached :main_image

  validates :name, :retail_price, :half_wholesale_price,
    :wholesale_price, :required_units_half_wholesale,
    :required_units_wholesale, presence: true

  validates :retail_price, numericality: true
  validates :half_wholesale_price, numericality: { lower_than_or_equal_to: :retail_price }
  validates :wholesale_price, numericality: { lower_than_or_equal_to: :half_wholesale_price }

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

  def build_boxes_json(box_names, box_units)
    return unless box_names and box_units
    boxes_array = Array.new
    box_names.each.with_index do |box_name, indx|
      boxes_array << {name: box_names[indx], units: box_units[indx].to_i}
    end
    Rails.logger.info "<<< boxes_array: #{boxes_array}"
    self.boxes = boxes_array
  end
  
end
