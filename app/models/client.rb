class Client < ApplicationRecord
  include Searchable
  include SoftDeletable

  before_save { self.email = email.downcase }
  belongs_to :user
  belongs_to :city

  validates :name, :address, :colony, :zc, presence: true
  validates :name, :colony, length: { in: 6..75 }
  validates :zc, length: { in: 4..8 }
  validates :address, length: { in: 6..150 }

  validates :password, :password_confirmation,
    presence: true, length: { in: 6..20 }, on: :create

  validates :email, format: { with: /\A.+@.+\z/ }
  validates :email, uniqueness: { case_sensitive: false }, on: :create
  validates_confirmation_of :email, on: :create

end
