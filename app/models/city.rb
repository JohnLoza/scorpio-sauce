class City < ApplicationRecord
  belongs_to :state

  scope :order_by_name, -> (way = :asc) { order(name: way) }

  def to_s
    name
  end
end
