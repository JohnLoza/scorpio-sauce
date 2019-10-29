class State < ApplicationRecord
  has_many :cities

  scope :order_by_name, -> (way = :asc) { order(name: way) }

  def to_s
    name
  end
end
