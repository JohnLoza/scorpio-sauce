class Admin::WarehouseShipmentsController < ApplicationController
  def index
    @pagy, @warehouse_shipments = pagy(
      WarehouseShipment.recent
        .includes(:user, :receiver, :warehouse)
    )
  end

  def show
    @warehouse_shipment = WarehouseShipment.find(params[:id])
    @product_names = @warehouse_shipment.product_names
  end

  def new
    @warehouse_shipment = WarehouseShipment.new
  end

  def create
    @warehouse_shipment = WarehouseShipment.new(warehouse_shipment_params)
    if @warehouse_shipment.save
      flash[:success] = t(".success")
      redirect_to [:admin, @warehouse_shipment]
    else
      render 'new'
    end
  end

  def destroy
    @warehouse_shipment = WarehouseShipment.find(params[:id])
    if @warehouse_shipment.destroy
      flash[:success] = t(".success")
    else
      flash[:info] = t(".failure")
    end
    redirect_to admin_warehouse_shipments_path
  end

  def process_shipment
    @warehouse_shipment = WarehouseShipment.find(params[:id])

    if @warehouse_shipment.process_shipment(current_user)
      flash[:success] = t(".success")
    else
      flash[:info] = t(".failure")
    end

    @product_names = @warehouse_shipment.product_names
    render :show
  end

  def report
    @warehouse_shipment = WarehouseShipment.find(params[:id])

    if @warehouse_shipment.update_attributes(report_params(@warehouse_shipment.products))
      flash[:success] = t(".success")
    else
      flash[:info] = t(".failure")
    end

    @product_names = @warehouse_shipment.product_names
    render :show
  end

  def process_report
    @warehouse_shipment = WarehouseShipment.find(params[:id])

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
      {
        user_id: current_user.id,
        warehouse_id: params[:warehouse_shipment][:warehouse_id],
        products: params[:products].values
      }
    end

    def report_params(products)
      products.each_with_index do |product, indx|
        products[indx]["real_units"] = params[:real_units][indx]
      end

      {
        products: products,
        report: { message: params[:report][:message] },
        status: WarehouseShipment::STATUS[:reported]
      }
    end

end
