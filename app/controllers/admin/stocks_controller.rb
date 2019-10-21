class Admin::StocksController < ApplicationController
  def index
    params[:filters] = {} unless params[:filters]
    w_id = params[:filters][:warehouse_id] || current_user.warehouse_id

    @warehouse = Warehouse.find(w_id)

    @stocks = Stock.available.by_warehouse(w_id)
      .by_product(params[:filters][:product_id])
      .order(:product_id).includes(:product)
  end
end
