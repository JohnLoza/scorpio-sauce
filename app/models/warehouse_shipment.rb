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
  validate :products_hash_keys

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

  def deletable?
    [STATUS[:new], STATUS[:devolution]].include?(self.status)
  end

  def reported?
    [STATUS[:reported], STATUS[:devolution_reported]].include?(self.status)
  end

  def devolution?
    [
      STATUS[:devolution],
      STATUS[:devolution_reported],
      STATUS[:devolution_processed]
    ].include?(self.status)
  end

  def processed?
    [STATUS[:processed], STATUS[:devolution_processed]].include?(self.status)
  end

  def process_shipment(user)
    self.status = self.devolution? ? STATUS[:devolution_processed] : STATUS[:processed]
    begin
      ActiveRecord::Base.transaction do
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
      end # transaction end
    rescue => exception
      self.errors.add(:products, exception.message)
    end
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

    def set_processed_status
      if self.devolution?
        STATUS[:devolution_processed]
      else
        STATUS[:processed]
      end
    end

    def products_hash_keys
      unless self.products.present?
        self.errors.add(:products, I18n.t("errors.messages.invalid"))
        return
      end

      self.products.each do |product|
        required_keys = ["product_id", "units", "batch", "expires_at"]

        product.keys.each do |key|
          if required_keys.include?(key) or key == "real_units"
            required_keys.delete(key)
          else
            self.errors.add(:products, I18n.t("errors.messages.invalid"))
          end
        end

        if required_keys.any?
          self.errors.add(:products, I18n.t("errors.messages.invalid"))
        end
      end

    end

end
