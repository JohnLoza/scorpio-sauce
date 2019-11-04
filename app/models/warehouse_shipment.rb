class WarehouseShipment < ApplicationRecord
  before_create :set_new_status

  STATUS = {
    new: "new".freeze,
    reported: "reported".freeze,
    processed: "processed".freeze,
    devolution: "devolution".freeze,
    devolution_reported: "devolution_reported".freeze,
    devolution_processed: "devolution_processed".freeze
  }

  belongs_to :user
  belongs_to :receiver, class_name: :User, foreign_key: :receiver_user_id, optional: true
  belongs_to :warehouse

  validates :products, presence: true

  scope :by_warehouse, -> (w_id) { where(warehouse_id: w_id) if w_id }
  scope :recent, -> { order(created_at: :desc) }

  def product_names
    product_ids = self.products.map{ |p| p["product_id"] }.uniq
    products = Product.where(id: product_ids).pluck(:id, :name)
    Hash[products]
  end

  def processable?
    [STATUS[:new], STATUS[:devolution]].include?(self.status)
  end

  def reportable?
    [STATUS[:new], STATUS[:devolution]].include?(self.status)
  end

  def reported?
    [STATUS[:reported], STATUS[:devolution_reported]].include?(self.status)
  end

  def deletable?
    [STATUS[:new], STATUS[:devolution]].include?(self.status)
  end

  def devolution?
    [
      STATUS[:devolution],
      STATUS[:devolution_reported],
      STATUS[:devolution_processed]
    ].include?(self.status)
  end

  def set_processed_status
    if self.devolution?
      self.status = STATUS[:devolution_processed]
    else
      self.status = STATUS[:processed]
    end
  end

  def process_shipment(user)
    ActiveRecord::Base.transaction do
      begin
        self.set_processed_status()
        self.update_attributes!(receiver_user_id: user.id)
        self.products.each do |product|
          if s = Stock.find_by(product_id: product["product_id"], warehouse_id: self.warehouse_id, batch: product["batch"])
            units_to_add = (product["real_units"] || product["units"]).to_i
            s.add!(units_to_add)
          else
            s = Stock.create!(stock_params(product))
          end
          Transaction.create!(transaction_params(s, product))
        end
      rescue => exception
        self.errors.add(:products, exception.message)
        raise ActiveRecord::Rollback
      end
    end # transaction end
  end

  def process_shipment_report(user)
    process_shipment(user)
  end

  private
    def set_new_status
      self.status = STATUS[:new] unless self.status.present?
    end

    def stock_params(product)
      {
        product_id: product["product_id"],
        warehouse_id: self.warehouse_id,
        units: product["real_units"] || product["units"],
        batch: product["batch"],
        expires_at: product["expires_at"]
      }
    end

    def transaction_params(stock, product)
      {
        stock_id: stock.id,
        user_id: self.receiver_user_id,
        units: product["real_units"] || product["units"],
        units_post_transaction: stock.units,
        incoming: true,
        concept: "incoming"
      }
    end

end
