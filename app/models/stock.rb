class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :warehouse

  validates :units, :batch, :expires_at, presence: true
  validate :batch_uniqueness, on: :create

  scope :available, -> (ammount = 1) { where("units >= ?", ammount) }
  scope :by_warehouse, -> (w_id) { where(warehouse_id: w_id) }
  scope :by_product, -> (p_ids){
    return all unless p_ids.present?
    where(product_id: p_ids)
  }
  scope :by_batch, -> (batch) { find_by(batch: batch) }
  scope :depleted, -> { where(units: 0) }

  def batch_uniqueness
    existing_batch = Stock.find_by(batch: batch, warehouse_id: warehouse_id)
    if existing_batch
      self.errors.add(:batch, I18n.t("errors.batch_in_use", batch: batch))
    end
  end
end
