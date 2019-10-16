class User < ApplicationRecord
  include Searchable
  include SoftDeletable

  ROLES = {
    admin: "ADMIN"
  }

  before_save { self.email = email.downcase }
  has_secure_password

  belongs_to :warehouse

  validates :name, :email, :cellphone,
    :roles, presence: true

  validates :name, :email, length: { in: 6..100 }

  validates :password, :password_confirmation,
    presence: true, length: { in: 6..20 }, on: :create

  validates :email, format: { with: /\A.+@.+\z/ }
  validates :email, uniqueness: { case_sensitive: false }, on: :create
  validates :email, confirmation: true

  scope :non_admin, -> { where.not(roles: User::ROLES[:admin]) }
  scope :recent, -> { order(created_at: :desc) }
  scope :order_by_name, -> (way = :asc) { order(name: way) }
  scope :by_warehouse, -> (wid) { where(warehouse_id: wid) }
end
