class Warehouse < ApplicationRecord
  include SoftDeletable
  belongs_to :city

  validates :address, presence: true, length: { maximum: 100 }

  validates :telephone, presence: true, length: { in: 8..20 }

  scope :include_location, -> { includes(city: :state) }

  def to_s
    address
  end

  def to_param
    "#{id}-#{telephone}"
  end

  def self.for_select
    self.active.map{ |w| [w.address, w.id] }
  end

  def location
    "#{self.city}, #{self.city.state}"
  end
end
