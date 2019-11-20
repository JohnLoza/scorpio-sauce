class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :client
  has_many :details, class_name: :TicketDetail

  validates :total, :payment_method, presence: true

  validates :total, numericality: { greater_than: 0 }

  validates :payment_method, length: { maximum: 20 }

  scope :recent, -> { order(created_at: :desc) }
  scope :by_warehouse, -> (w_id) { where(warehouse_id: w_id) if w_id.present? }

  def canceled?
    self.canceled
  end

  def save_and_update_route_stock(route_stock)
    begin
      ActiveRecord::Base.transaction do
        self.save!
        unless route_stock
          raise StandardError, t("errors.route_stock_not_available")
        end
        route_stock.withdraw!(self)
      end
    rescue => exception
      self.errors.add(:details, exception.message)
      return false
    end
  end

  def cancel!(route_stock)
    begin
      self.update_attributes!(canceled: true)
      route_stock.add!(self)
    rescue => exception
      self.errors.add(:canceled, exception.message)
      return false
    end
  end
end
