class RouteStock < ApplicationRecord
  belongs_to :user
  belongs_to :supply_order

  before_create :set_products_units_left

  validates :products, presence: true

  scope :current_day, -> { where("created_at > ?", Date.today) }

  def withdraw!(ticket)
    ticket.details.each do |ticket_detail|
      indx = self.products.index {|e| e["product_id"].to_i == ticket_detail.product_id and e["batch"] == ticket_detail.batch }

      unless indx.present?
        raise StandardError, I18n.t("errors.route_stock_product_not_found", batch: ticket_detail.batch)
      end
      unless self.products[indx]["units_left"] >= ticket_detail.units
        raise StandardError, I18n.t("errors.not_enough_stock", batch: ticket_detail.batch)
      end

      self.products[indx]["units_left"] -= ticket_detail.units
    end

    self.save!
  end

  def add!(ticket)
    ticket.details.each do |ticket_detail|
      indx = self.products.index {|e| e["product_id"].to_i == ticket_detail.product_id and e["batch"] == ticket_detail.batch }
      unless indx.present?
        raise StandardError, I18n.t("errors.route_stock_product_not_found", batch: ticket_detail.batch)
      end

      self.products[indx]["units_left"] += ticket_detail.units
    end

    self.save!
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
