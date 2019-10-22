class User < ApplicationRecord
  include Searchable
  include SoftDeletable

  ROLES = {
    admin: "admin".freeze,
    admin_staff: "admin_staff".freeze,
    warehouse: "warehouse".freeze,
    delivery_man: "delivery_man".freeze
  }

  has_one_attached :avatar

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
  scope :not, -> (ids) { where.not(id: ids) }
  scope :recent, -> { order(created_at: :desc) }
  scope :order_by_name, -> (way = :asc) { order(name: way) }
  scope :by_warehouse, -> (wid) { where(warehouse_id: wid) }

  def to_s
    name
  end

  def to_param
    "#{id}-#{name}"
  end

  def self.available_roles
    ROLES.select {|key, value| key != :admin}
  end

  def self.roles_for_select
    available_roles = self.available_roles
    available_roles.map{|key, value| [I18n.t("roles.#{key}"), value] }
  end

  def rol
    self.roles
  end

  def is_a?(role)
    self.roles == role
  end

  def is_not_a?(role)
    self.roles != role
  end
  
end
