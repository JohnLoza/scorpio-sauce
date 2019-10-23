class Admin::StocksController < ApplicationController
  def index
    w_id = warehouse_id()

    @warehouse = Warehouse.find(w_id)

    @stocks = Stock.available.by_warehouse(w_id).by_product(params[:product_id])
      .order(:product_id).includes(:product)
  end

  private
    def warehouse_id
      params[:warehouse_id].blank? ? current_user.warehouse_id : params[:warehouse_id]
    end
    
end
