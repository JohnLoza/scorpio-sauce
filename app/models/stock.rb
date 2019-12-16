class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :warehouse
  has_many :transactions

  validates :units, :batch, :expires_at, presence: true

  validates :units, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates :batch, length: { maximum:15 }
  validate :batch_uniqueness, on: :create

  scope :available, -> (ammount = 1) { where("units >= ?", ammount) }
  scope :depleted, -> { where(units: 0) }
  scope :by_warehouse, -> (w_id) { where(warehouse_id: w_id) }
  scope :by_product, -> (p_ids){ where(product_id: p_ids) if p_ids.present? }
  scope :by_batch, -> (batch) { find_by(batch: batch) if batch.present? }

  scope :availability, -> (availability){
    if availability == "depleted"
      depleted()
    else
      available()
    end
  }

  def self.withdraw_supplies!(supplies, warehouse_id, user_id)
    supplies.each do |s_i|
      stock = Stock.find_by(warehouse_id: warehouse_id,
        product_id: s_i["product_id"], batch: s_i["batch"])
      raise StandardError, I18n.t("errors.product_not_found", batch: s_i["batch"]) unless stock

      stock.withdraw!(s_i["units"].to_i)
      Transaction.create!({
        stock_id: stock.id,
        user_id: user_id,
        units: s_i["units"].to_i,
        units_post_transaction: stock.units,
        incoming: false,
        concept: "route"
      })
    end
  end

  def withdraw!(quantity)
    unless self.has_minimum_stock?(quantity)
      raise StandardError, I18n.t("errors.not_enough_stock", batch: self.batch)
    end

    self.update_attributes!(units: self.units - quantity)
  end

  def add!(quantity)
    self.update_attributes!(units: self.units + quantity)
  end

  def has_minimum_stock?(required)
    units >= required
  end

  def data_for_qr()
    "#{self.product_id}|#{self.batch}"
  end

  private
    def batch_uniqueness
      existing_batch = Stock.find_by(batch: batch, warehouse_id: warehouse_id)
      if existing_batch
        self.errors.add(:batch, I18n.t("errors.batch_in_use", batch: batch))
      end
    end
end
