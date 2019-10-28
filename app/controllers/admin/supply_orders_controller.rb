class Admin::SupplyOrdersController < ApplicationController
  # index new create destroy supply
  def index
    params[:filters] = {} unless params[:filters]
    w_id = params[:filters][:warehouse_id] || current_user.warehouse_id

    @pagy, @supply_orders = pagy(
      SupplyOrder.by_warehouse(w_id).recent
        .includes(:user, :target_user, :supplier)
    )
  end

  def show
    @supply_order = SupplyOrder.find(params[:id])
    @product_names = @supply_order.product_names
  end

  def new
    @supply_order = SupplyOrder.new
  end

  def create
    @supply_order = SupplyOrder.new(supply_order_params)
    if @supply_order.save
      flash[:success] = t(".success")
      redirect_to [:admin, @supply_order]
    else
      render :new
    end
  end

  def destroy
    @supply_order = SupplyOrder.find(params[:id])
    if @supply_order.destroy
      flash[:success] = t(".success")
    else
      flash[:info] = t(".failure")
    end
    redirect_to admin_supply_orders_path
  end

  def supply
    @supply_order = SupplyOrder.find(params[:id])
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

end
