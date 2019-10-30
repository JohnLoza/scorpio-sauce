class RouteStock < ApplicationRecord
  belongs_to :user
  belongs_to :supply_order

  before_save :set_products_units_left

  validates :products, presence: true

  scope :current_day, -> { where("created_at > ?", Date.today) }

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
