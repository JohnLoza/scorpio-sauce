class WarehouseShipment < ApplicationRecord
  before_create :set_new_status

  STATUS = {
    new: "new".freeze,
    reported: "reported".freeze,
    processed: "processed".freeze
  }

  belongs_to :user
  belongs_to :receiver, class_name: :User, foreign_key: :receiver_user_id, optional: true
  belongs_to :warehouse

  validates :products, presence: true

  def product_names
    product_ids = self.products.map{ |p| p["product_id"] }
    products = Product.where(id: product_ids).pluck(:id, :name)
    Hash[products]
  end

  def processable?
    self.status == STATUS[:new]
  end

  def reportable?
    self.status == STATUS[:new]
  end

  def reported?
    self.status == STATUS[:reported]
  end

  def deletable?
    self.status == STATUS[:new]
  end

  def process_shipment(user)
    ActiveRecord::Base.transaction do
      begin
        self.products.each do |product|
          Stock.create!({
            product_id: product["product_id"],
            warehouse_id: self.warehouse_id, 
            units: product["real_units"] || product["units"],
            batch: product["batch"],
            expires_at: product["expires_at"]
          })
        end
        self.update_attributes!(status: STATUS[:processed], receiver_user_id: user.id)
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
      self.status = STATUS[:new]
    end
    
end
