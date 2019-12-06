class Api::TicketsController < ApiController
  def index
    @pagy, @tickets = pagy(@current_user.tickets.current_day.recent)

    data = @tickets.as_json(
      only: [:id, :total, :payment_method, :canceled],
      include: { client: { only: :name } }
    )

    response = {
      status: :completed,
      data: data,
      pagy: pagy_metadata(@pagy)
    }

    render json: JSON.pretty_generate(response)
  end

  def show
    @ticket = @current_user.tickets.find(params[:id])

    data = @ticket.as_json(
      only: [:total, :payment_method],
      include: {
        client: { only: :name },
        details: {
          only: [:units, :batch, :sub_total],
          include: {
            product: {only: :name}
          }
        }
      }
    )

    response = { status: :completed, data: data }
    render json: JSON.pretty_generate(response)
  end

  def create
    @ticket = build_ticket_and_details
    rs = @current_user.route_stocks.current_day.last

    if @ticket.save_and_update_route_stock(rs)
      data = @ticket.as_json()
      data["user_name"] = @current_user.name
      response = { status: :completed, data: data }
      render json: JSON.pretty_generate(response)
    else
      render_unprocessable_error(@ticket)
    end
  end

  def update
    @ticket = @current_user.tickets.current_day.where(params[:id]).take
    render_404 and return if @ticket.canceled?

    @ticket.invoice_required = params[:ticket][:invoice_required]
    @ticket.payment_method = params[:ticket][:payment_method]
    @ticket.cfdi = params[:ticket][:cfdi]

    if @ticket.save_and_update_route_stock
      response = { status: :completed, data: @ticket.as_json() }
      render json: JSON.pretty_generate(response)
    else
      render_unprocessable_error(@ticket)
    end
  end

  def destroy
    @ticket = @current_user.tickets.current_day.where(params[:id]).take
    render_404 and return if @ticket.canceled?

    rs = @current_user.route_stocks.current_day.last
    if @ticket.cancel!(rs)
      response = { status: :completed, data: @ticket.as_json() }
      render json: JSON.pretty_generate(response)
    else
      render_unprocessable_error(@ticket)
    end
  end

  private
    def ticket_params
      params.require(:ticket).permit(:client_id, :total, :invoice_required, :payment_method, :cfdi)
    end

    def build_ticket_and_details
      ticket = @current_user.tickets.build(ticket_params)
      params[:ticket][:details].each do |detail_params|
        permited_params = detail_params.permit(:product_id, :units, :batch, :sub_total)
        ticket.details.build(permited_params)
      end

      ticket
    end

end
