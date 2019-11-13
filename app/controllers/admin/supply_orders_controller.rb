class Admin::SupplyOrdersController < ApplicationController
  before_action :load_supply_orders, only: :index
  load_and_authorize_resource

  def index
  end

  def show
    @product_names = @supply_order.product_names
  end

  def new
  end

  def create
    if @supply_order.save
      flash[:success] = t(".success")
      redirect_to [:admin, @supply_order]
    else
      render :new
    end
  end

  def destroy
    if @supply_order.destroy
      flash[:success] = t(".success")
    else
      flash[:info] = t(".failure")
    end
    redirect_to admin_supply_orders_path
  end

  def supply
    if @supply_order.supply(supplies_params)
      flash[:success] = t(".success")
      redirect_to [:admin, @supply_order]
    else
      @product_names = @supply_order.product_names
      render :show
    end
  end

  private
    def supply_order_params
      unless params[:supply_order].present? and params[:products].present?
        raise ActionController::ParameterMissing, :products
      end

      {
        user_id: current_user.id,
        target_user_id: params[:supply_order][:target_user_id],
        warehouse_id: current_user.warehouse_id,
        to_supply: params[:products].values
      }
    end

    def supplies_params
      {
        supplier: current_user.id,
        supplies: params[:products].values
      }
    end

    def load_supply_orders
      w_id = filter_params(require: :warehouse_id, default_value: current_user.warehouse_id)

      @pagy, @supply_orders = pagy(
        SupplyOrder.by_warehouse(w_id).recent
          .includes(:user, :target_user, :supplier)
      )
    end

end
