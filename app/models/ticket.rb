class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :client
  has_many :details, class_name: :TicketDetail

  validates :total, :payment_method, presence: true

  validates :total, numericality: { greater_than: 0 }

  validates :payment_method, length: { maximum: 20 }

  scope :recent, -> { order(created_at: :desc) }

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
    end
  end

end
