class RouteStock < ApplicationRecord
  belongs_to :user
  belongs_to :supply_order

  before_save :set_products_units_left

  validates :products, presence: true

  scope :current_day, -> { where("created_at > ?", Date.today).take() }

  def withdraw!(@ticket)
    @ticket.details.each do |ticket_detail|
      product = self.products.select {|e| e["product_id"].to_i == ticket_detail.product_id and e["batch"] == ticket_detail.batch }

      unless product
        raise StandardError, I18n.t("errors.route_stock_product_not_found", batch: ticket_detail.batch)
      end
      unless product["units_left"] >= ticket_detail.units
        raise StandardError, I18n.t("errors.not_enough_stock", batch: ticket_detail.batch)
      end

      product["units_left"] -= ticket_detail.units
    end
  end

  private
    def set_products_units_left
      self.products.each_with_index do |product, indx|
        unless product["units"].kind_of? Integer
          self.products[indx]["units"] = product["units"].to_i
        end
        self.products[indx]["units_left"] = self.products[indx]["units"]
      end
    end
end
