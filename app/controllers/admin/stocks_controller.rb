class Admin::StocksController < ApplicationController
  skip_authorization_check only: :batch_search

  before_action :load_stocks, only: :index
  before_action :load_stock_for_qr, only: :print_qr
  load_and_authorize_resource

  def index
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

  def print_qr
    require 'rqrcode'
    @qrcode = RQRCode::QRCode.new(@stock.data_for_qr)

    render :print_qr, layout: false
  end

  def batch_search
    return unless params[:batch_search].present?
    @product_id = params[:batch_search][:product_id]
    @batch = params[:batch_search][:batch]

    @stock = Stock.where(product_id: @product_id, batch: @batch).includes(:warehouse)

    @pagy, @tickets = pagy(
      Ticket.joins(:details).merge(
        TicketDetail.where(product_id: @product_id, batch: @batch)
      ).distinct.includes(:client, :details)
    )
  end

  private
    def warehouse_id
      params[:filters] = params[:filters] || {}
      params[:filters][:warehouse_id].blank? ? current_user.warehouse_id : params[:filters][:warehouse_id]
    end

    def load_stocks
      w_id = filter_params(require: :warehouse_id, default_value: current_user.warehouse_id)
      @warehouse = Warehouse.find(w_id)

      @pagy, @stocks = pagy(
        Stock.by_warehouse(w_id)
          .availability(filter_params(require: :availability))
          .by_product(filter_params(require: :product_id))
          .order(:product_id).includes(:product)
      )
    end

    def load_stock_for_qr
      if params[:id] == "0" and params[:qr].present?
        @stock = Stock.new(params[:qr].permit(:product_id, :batch, :expires_at))
      else
        @stock = Stock.find(params[:id])
      end
    end

end
