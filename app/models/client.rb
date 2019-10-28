class Client < ApplicationRecord
  include Searchable
  include SoftDeletable

  belongs_to :user
  belongs_to :city

  validates :name, :telephone, :address, :colony, :zc,
    :lat, :lng, presence: true
  validates :name, :colony, length: { in: 6..75 }
  validates :zc, length: { in: 4..8 }
  validates :address, length: { in: 6..150 }

  def to_s
    name
  end

  def to_param
    "#{id}-#{name}"
  end

  def location
    "#{self.city}, #{self.city.state}"
  end

  def full_address
    "#{address}, #{colony}, #{zc}"
  end
end
