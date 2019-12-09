class Admin::TicketsController < ApplicationController
  before_action :load_tickets, only: :index
  load_and_authorize_resource

  def index
  end

  def show
  end

  def save_invoice_folio
    if @ticket.update_attributes(invoice_folio: params[:ticket][:invoice_folio])
      flash[:success] = "invoice folio saved"
    else
      flash[:info] = "oops failed"
    end

    redirect_to admin_tickets_path
  end

  private
    def load_tickets
      w_id = filter_params(require: :warehouse_id, default_value: current_user.warehouse_id)
      # @warehouse = Warehouse.find(w_id)

      @pagy, @tickets = pagy(
        Ticket.recent.joins(:user).merge(
          User.by_warehouse(w_id)
        ).includes(:client, :user)
      )
    end

end
