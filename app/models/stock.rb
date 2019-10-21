class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :warehouse

  validates :units, :batch, :expiration_date, presence: true

  scope :available, -> (ammount = 1) { where("units >= ?", ammount) }
  scope :by_warehouse, -> (w_id) { where(warehouse_id: w_id) }
  scope :by_product, -> (p_ids){
    return all unless p_ids.present?
    where(product_id: p_ids)
  }
  scope :depleted, -> { where(units: 0) }
end
