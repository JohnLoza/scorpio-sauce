class SupplyOrder < ApplicationRecord
  belongs_to :user
  belongs_to :target_user, class_name: :User, foreign_key: :target_user_id
  belongs_to :supplier, class_name: :User, foreign_key: :supplier_user_id, optional: true
  belongs_to :warehouse

  validates :to_supply, presence: true

  scope :by_warehouse, -> (w_id) { where(warehouse_id: w_id) }
  scope :processed, -> (processed = true) { where(processed: processed) }
  scope :recent, -> { order(created_at: :desc) }

  def deletable_by?(user)
    processed == false and user_id == user.id
  end

  def processable?
    !processed
  end

  def supply(options = {})
    raise ArgumentError, "supplier option required" unless options[:supplier].present?
    raise ArgumentError, "supplies option required" unless options[:supplies].present?

    unless valid_supplies?(options[:supplies])
      return false
    end

    ActiveRecord::Base.transaction do 
      begin
        self.update_attributes!(supplier_user_id: options[:supplier],
          supplies: options[:supplies], processed: true)

        Stock.withdraw_supplies!(options[:supplies], self.warehouse_id)

        RouteStock.create!(user_id: self.target_user_id, 
          products: options[:supplies])
      rescue => exception
        self.processed = false
        self.errors.add(:supplies, exception.message)
        raise ActiveRecord::Rollback
      end
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
  
end
