class Admin::WarehousesController < ApplicationController
  def index
    @warehouses = Warehouse.active.include_location
  end

  def show
    @warehouse = Warehouse.find(params[:id])
  end

  def new
    @warehouse = Warehouse.new
    @states = State.all
    @cities = Array.new

    params[:warehouse] = { city_id: nil, state_id: nil }
  end

  def create
    @warehouse = Warehouse.new(warehouse_params)

    if @warehouse.save
      flash[:success] = t(".success", warehouse: @warehouse)
      redirect_to [:admin, @warehouse]
    else
      @states = State.all
      @cities = City.where(state_params).order_by_name
      render "new"
    end
  end

  def edit
    @warehouse = Warehouse.find(params[:id])
    
    city = @warehouse.city
    params[:warehouse] = { city_id: city.id, state_id: city.state_id }

    @states = State.all
    @cities = City.where(state_params).order_by_name
  end

  def update
    @warehouse = Warehouse.find(params[:id])
    if @warehouse.update_attributes(warehouse_params)
      flash[:success] = t(".success", warehouse: @warehouse)
      redirect_to [:admin, @warehouse]
    else
      @states = State.all
      @cities = City.where(state_params).order_by_name
      render "edit"
    end
  end

  def destroy
    @warehouse = Warehouse.find(params[:id])
    if @warehouse.destroy
      flash[:success] = t(".success", warehouse: @warehouse, url: restore_admin_warehouse_path(@warehouse))
    else
      flash[:info] = t(".failure", warehouse: @warehouse)
    end
    redirect_to admin_warehouses_path
  end

  def restore
    @warehouse = Warehouse.find(params[:id])
    if @warehouse.restore!
      flash[:success] = t(".success", warehouse: @warehouse)
      redirect_to [:admin, @warehouse]
    else
      flash[:info] = t(".failure", warehouse: @warehouse)
      redirect_to admin_warehouses_path
    end
  end

  private
    def warehouse_params
      params.require(:warehouse).permit(:address, :telephone, :city_id)
    end

    def state_params
      params.require(:warehouse).permit(:state_id)
    end
end
