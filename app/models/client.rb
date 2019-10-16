class Product < ApplicationRecord
  include Searchable
  include SoftDeletable

  before_save { self.email = email.downcase }
  has_secure_password

  belongs_to :warehouse

  validates :name, :email, :cellphone,
    :roles, presence: true

  validates :password, :password_confirmation,
    presence: true, length: { in: 6..20 }, on: :create

  validates :email, format: { with: /\A.+@.+\z/ }
  validates :email, uniqueness: { case_sensitive: false }, on: :create
  validates_confirmation_of :email, on: :create

  scope :recent, -> { order(created_at: :desc) }
  scope :order_by_name, -> (way = :asc) {
    order(name: way)
  }
  scope :order_by_price, -> (way = :asc) {
    order(retail_price: way)
  }
end

create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
  t.string "name"
  t.decimal "retail_price", precision: 8, scale: 2
  t.decimal "half_wholesale_price", precision: 8, scale: 2
  t.decimal "wholesale_price", precision: 8, scale: 2
  t.integer "required_units_half_wholesale"
  t.integer "required_units_wholesale"
  t.json "boxes"
  t.datetime "deleted_at"
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
  t.index ["deleted_at"], name: "index_products_on_deleted_at"
end
