class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :warehouse

  validates :units, :batch, :expires_at, presence: true
  validates :units, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :batch_uniqueness, on: :create

  scope :available, -> (ammount = 1) { where("units >= ?", ammount) }
  scope :by_warehouse, -> (w_id) { where(warehouse_id: w_id) }
  scope :by_product, -> (p_ids){
    return all unless p_ids.present?
    where(product_id: p_ids)
  }
  scope :by_batch, -> (batch) { find_by(batch: batch) }
  scope :depleted, -> { where(units: 0) }

  def self.withdraw_supplies!(supplies, warehouse_id)
    supplies.each do |s_i|
      stock = Stock.find_by(warehouse_id: warehouse_id,
        product_id: s_i["product_id"], batch: s_i["batch"])
      
      unless stock
        raise StandardError, I18n.t("errors.product_not_found", batch: s_i["batch"])
      end

      stock.withdraw!(s_i["units"].to_i)
    end
  end

  def withdraw!(quantity)
    unless self.has_minimum_stock?(quantity)
      raise StandardError, I18n.t("errors.not_enough_stock", batch: self.batch)
    end

    self.update_attributes!(units: units - quantity)
  end

  def batch_uniqueness
    existing_batch = Stock.find_by(batch: batch, warehouse_id: warehouse_id)
    if existing_batch
      self.errors.add(:batch, I18n.t("errors.batch_in_use", batch: batch))
    end
  end

  def has_minimum_stock?(required)
    units >= required
  end
end
