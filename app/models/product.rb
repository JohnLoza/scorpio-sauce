class Product < ApplicationRecord
  include Searchable
  include SoftDeletable

  has_one_attached :main_image

  validates :name, :retail_price, :half_wholesale_price,
    :wholesale_price, :required_units_half_wholesale,
    :required_units_wholesale, presence: true

  validates :retail_price, numericality: true

  validate :prices_incongruencies

  validates :required_units_half_wholesale,
    numericality: { only_integer: true, greater_than: 0 }

  validate :required_units_wholesale_is_greater_than_half_wholesales

  scope :by_id, -> (id) { where(id: id) if id.present? }
  scope :recent, -> { order(created_at: :desc) }
  scope :order_by_name, -> (way = :asc) {
    order(name: way)
  }
  scope :order_by_price, -> (way = :asc) {
    order(retail_price: way)
  }

  def to_s
    name
  end

  def to_param
    "#{id}-#{name}"
  end

  def as_json(options = nil)
    unless options.present?
      options = { except: [:boxes, :deleted_at, :created_at, :updated_at] }
    end

    super(options)
  end

  def self.for_select(options = {})
    products = []
    if options[:id].present?
      products = self.where(id: options[:id])
    else
      products = self.active
    end

    products.map{ |p| [p.name, p.id] }
  end

  private
    def prices_incongruencies
      return unless retail_price and half_wholesale_price and wholesale_price

      if half_wholesale_price > retail_price
        self.errors.add(:half_wholesale_price, I18n.t("errors.messages.greater_than_or_equal_to", count: retail_price))
      end

      if wholesale_price > half_wholesale_price
        self.errors.add(:wholesale_price, I18n.t("errors.messages.greater_than_or_equal_to", count: half_wholesale_price))
      end
    end

    def required_units_wholesale_is_greater_than_half_wholesales
      return unless required_units_wholesale and required_units_half_wholesale

      if required_units_wholesale <= required_units_half_wholesale
        self.errors.add(:required_units_wholesale, I18n.t("error.messages.greater_than", count: required_units_half_wholesale))
      end
    end
end
