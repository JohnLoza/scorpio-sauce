class Admin::WarehouseShipmentsController < ApplicationController
  before_action :load_warehouse_shipments, only: :index
  load_and_authorize_resource

  def index
  end

  def show
    @product_names = @warehouse_shipment.product_names
  end

  def new
  end

  def create
    if @warehouse_shipment.save
      flash[:success] = t(".success")
      redirect_to [:admin, @warehouse_shipment]
    else
      render 'new'
    end
  end

  def destroy
    if @warehouse_shipment.destroy
      flash[:success] = t(".success")
    else
      flash[:info] = t(".failure")
    end
    redirect_to admin_warehouse_shipments_path
  end

  def process_shipment
    if @warehouse_shipment.process_shipment(current_user)
      flash[:success] = t(".success")
    else
      flash[:info] = t(".failure")
    end

    @product_names = @warehouse_shipment.product_names
    render :show
  end

  def report
    if @warehouse_shipment.update_attributes(report_params(@warehouse_shipment.products))
      flash[:success] = t(".success")
    else
      flash[:info] = t(".failure")
    end

    @product_names = @warehouse_shipment.product_names
    render :show
  end

  def process_report
    if @warehouse_shipment.process_shipment_report(current_user)
      flash[:success] = t(".success")
    else
      flash[:info] = t(".failure")
    end

    @product_names = @warehouse_shipment.product_names
    render :show
  end

  private
    def warehouse_shipment_params
      unless params[:warehouse_shipment].present? and params[:products].present?
        raise ActionController::ParameterMissing, :warehouse_shipment
      end

      {
        user_id: current_user.id, status: params[:warehouse_shipment][:status],
        warehouse_id: params[:warehouse_shipment][:warehouse_id],
        products: params[:products].values
      }
    end

    def report_params(products)
      products.each_with_index do |product, indx|
        products[indx]["real_units"] = params[:real_units][indx]
      end

      params_hash = {
        products: products,
        report: { message: params[:report][:message] }
      }

      if @warehouse_shipment.devolution?
        params_hash[:status] = WarehouseShipment::STATUS[:devolution_reported]
      else
        params_hash[:status] = WarehouseShipment::STATUS[:reported]
      end

      return params_hash
    end

    def load_warehouse_shipments
      default_value = current_user.role?(:warehouse) ? current_user.warehouse_id : nil
      w_id = filter_params(require: :warehouse_id, default_value: default_value)

      @pagy, @warehouse_shipments = pagy(
        WarehouseShipment.recent.by_warehouse(w_id)
          .includes(:user, :receiver, :warehouse)
      )
    end

end
