class Admin::StocksController < ApplicationController
  def index
    w_id = filter_params(require: :warehouse_id, default_value: current_user.warehouse_id)
    @warehouse = Warehouse.find(w_id)

    @pagy, @stocks = pagy(
      Stock.available.by_warehouse(w_id)
        .by_product(filter_params(require: :product_id))
        .order(:product_id).includes(:product)
    )
  end

  def transactions
    w_id = filter_params(require: :warehouse_id, default_value: current_user.warehouse_id)
    @warehouse = Warehouse.find(w_id)

    @pagy, @transactions = pagy(
      Transaction.all
        .order(created_at: :desc)
        .joins(:stock).merge(
          Stock.by_warehouse(w_id).by_product(filter_params(require: :product_id))
        ).includes(:user, stock: :product),
      items: 50
    )
  end

  private
    def warehouse_id
      params[:filters] = params[:filters] || {}
      params[:filters][:warehouse_id].blank? ? current_user.warehouse_id : params[:filters][:warehouse_id]
    end

end
