class Client < ApplicationRecord
  include Searchable
  include SoftDeletable

  belongs_to :user
  belongs_to :city

  validates :name, :telephone, :address, :colony, :zc,
    :lat, :lng, presence: true

  validates :name, length: { maximum: 50 }

  validates :telephone, length: { in: 10..20 }

  validates :address, length: { maximum: 150 }

  validates :colony, length: { maximum: 25 }

  validates :zc, length: { is: 5 }

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

  def google_maps_link
    "https://www.google.com/maps/search/?api=1&query=#{lat},#{lng}"
  end

  def as_json(options = nil)
    unless options.present?
      options = {
        except: [:user_id, :city_id, :deleted_at, :created_at, :updated_at],
        include: { city: { include: :state } }
      }
    end

    super(options)
  end
end
