class Warehouse < ApplicationRecord
  belongs_to :city

  validates :address, presence: true, length: { in: 6..100 }
  validates :telephone, presence: true, length: { in: 6..20 }
end
