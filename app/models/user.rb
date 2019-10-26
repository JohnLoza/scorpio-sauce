class User < ApplicationRecord
  include Searchable
  include SoftDeletable

  ROLES = {
    admin: "admin".freeze,
    admin_staff: "admin_staff".freeze,
    warehouse: "warehouse".freeze,
    delivery_man: "delivery_man".freeze
  }

  before_save { self.email = email.downcase }
  has_secure_password

  has_one_attached :avatar

  belongs_to :warehouse
  has_many :clients

  validates :name, :email, :cellphone,
    :role, presence: true

  validates :name, :email, length: { in: 6..100 }

  validates :password, :password_confirmation,
    presence: true, length: { in: 6..20 }, on: :create

  validates :email, format: { with: /\A.+@.+\z/ }
  validates :email, uniqueness: { case_sensitive: false }, on: :create
  validates :email, confirmation: true

  scope :non_admin, -> { where.not(role: User::ROLES[:admin]) }
  scope :not, -> (ids) { where.not(id: ids) }
  scope :recent, -> { order(created_at: :desc) }
  scope :order_by_name, -> (way = :asc) { order(name: way) }
  scope :by_warehouse, -> (w_id) { where(warehouse_id: w_id) if w_id.present? }
  scope :by_role, -> (role) { where(role: role ) if role.present? }

  def to_s
    name
  end

  def to_param
    "#{id}-#{name}"
  end

  def admin?
    self.role == ROLES[:admin]
  end

  def role?(role)
    if self.admin?
      return true
    else
      self.role == ROLES[role]
    end
  end

  def self.roles_without(role)
    if role.kind_of?(Array)
      ROLES.select{|key, value| !role.include?(key)}
    elsif role.kind_of?(Symbol)
      ROLES.select{|key, value| key != role}
    else
      raise ArgumentError, "Parameter should be a Symbol or an Array"
    end
  end

  def self.roles_for_select
    roles = self.roles_without(:admin)
    roles = roles.map{|key, value| [I18n.t("roles.#{key}"), value]}
    roles.sort{|a,b| a.first <=> b.first}
  end

  def self.for_select(options = {})
    raise ArgumentError, "role option is required" unless options[:role].present?
    raise ArgumentError, "warehouse_id option is required" unless options[:warehouse_id].present?

    User.by_warehouse(options[:warehouse_id]).by_role(ROLES[options[:role]])
      .map{ |user| [user.name, user.id] }
  end
end
