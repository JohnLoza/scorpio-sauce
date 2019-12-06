class SupplyOrder < ApplicationRecord
  STATUS = {
    new: "new".freeze,
    processed: "processed".freeze,
    canceled: "canceled".freeze
  }

  belongs_to :user
  belongs_to :target_user, class_name: :User, foreign_key: :target_user_id
  belongs_to :supplier, class_name: :User, foreign_key: :supplier_user_id, optional: true
  belongs_to :warehouse
  has_one :route_stock

  before_create { self.status = STATUS[:new] }

  validates :to_supply, presence: true
  validate :to_supply_hash_keys

  scope :by_warehouse, -> (w_id) { where(warehouse_id: w_id) }
  scope :by_status, -> (status) { where(status: status) }
  scope :recent, -> { order(created_at: :desc) }

  def cancelable?
    self.status == STATUS[:new]
  end

  def processable?
    self.status == STATUS[:new]
  end

  def supply(options = {})
    raise ActiveRecord::RecordInvalid, "supplier option required" unless options[:supplier].present?
    raise ActiveRecord::RecordInvalid, "supplies option required" unless options[:supplies].present?

    unless valid_supplies?(options[:supplies])
      return false
    end

    begin
      ActiveRecord::Base.transaction do
        self.build_route_stock(user_id: self.target_user_id, products: options[:supplies])
        self.update_attributes!(supplier_user_id: options[:supplier], status: STATUS[:processed])
        Stock.withdraw_supplies!(options[:supplies], self.warehouse_id, options[:supplier])
      end
    rescue => exception
      self.status = STATUS[:new]
      self.errors.add(:supplies, exception.message)
      return false
    end
  end

  def product_ids
    self.to_supply.map{ |product_hash| product_hash["product_id"] }.uniq
  end

  def product_names
    product_ids = self.to_supply.map{ |p| p["product_id"] }.uniq
    products = Product.where(id: product_ids).pluck(:id, :name)
    Hash[products]
  end

  private
    def valid_supplies?(supplies)
      products_to_supply = Hash[self.to_supply.map{ |s| [s["product_id"], s["units"].to_i] }]

      supplies.each do |s_i|
        products_to_supply[s_i["product_id"]] -= s_i["units"].to_i
      end

      if products_to_supply.values.select{ |value| value > 0 }.any?
        self.errors.add(:supplies, I18n.t("errors.incomplete_supplies"))
      end
      return !self.errors.any?
    end

    def to_supply_hash_keys
      return unless self.to_supply.present?

      self.to_supply.each do |product_to_supply|
        required_keys = ["product_id", "units"]

        product_to_supply.keys.each do |key|
          if required_keys.include?(key)
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
