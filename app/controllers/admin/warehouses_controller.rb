class Admin::WarehousesController < ApplicationController
  before_action :load_warehouses, only: :index
  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
    @states = State.all
    @cities = Array.new

    params[:warehouse] = { city_id: nil, state_id: nil }
  end

  def create
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
    city = @warehouse.city
    params[:warehouse] = { city_id: city.id, state_id: city.state_id }

    @states = State.all
    @cities = City.where(state_params).order_by_name
  end

  def update
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
    if @warehouse.destroy
      flash[:success] = t(".success", warehouse: @warehouse, url: restore_admin_warehouse_path(@warehouse))
    else
      flash[:info] = t(".failure", warehouse: @warehouse)
    end
    redirect_to admin_warehouses_path
  end

  def restore!
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

    def load_warehouses
      @warehouses = Warehouse.active.include_location
    end
end
