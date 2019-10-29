# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    case user.role
    when User::ROLES[:admin]

      can :manage, :all
      cannot [:update, :destroy], User, role: User::ROLES[:admin]
      can :update, User, id: user.id

    when User::ROLES[:human_resources]

      can :manage, User, role: User.roles_without(:admin).values, deleted_at: nil
      can :restore, User
      cannot [:update, :destroy], User, id: user.id
      can :read, Client

    when User::ROLES[:admin_staff]
      can :read, User, role: User.roles_without(:admin).values, deleted_at: nil

      can :read, Product
      can :read, Client

      can :read, Stock

      can [:read, :create], WarehouseShipment
      can :destroy, WarehouseShipment, user_id: user.id, status: WarehouseShipment::STATUS[:new]
      can :process_report, WarehouseShipment, user_id: user.id

      can [:read, :create], SupplyOrder
      can :destroy, SupplyOrder, user_id: user.id, supplier_user_id: nil

    when User::ROLES[:warehouse]
      can :read, Stock

      can [:read, :process_shipment, :report], WarehouseShipment, warehouse_id: user.warehouse_id

      can [:read, :supply], SupplyOrder, warehouse_id: user.warehouse_id
    end
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
