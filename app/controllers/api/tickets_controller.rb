class Admin::TicketsController < ApiController
  def index
    @pagy, @tickets = pagy(@current_user.tickets)

    response = {
      status: :completed,
      data: @tickets.as_json(),
      pagy: pagy_metadata(@pagy)
    }

    render json: JSON.pretty_generate(response)
  end

  def show
    @ticket = @current_user.tickets.find(params[:id])

    response = { status: :completed, data: @ticket.as_json() }
    render json: JSON.pretty_generate(response)
  end

  def create
    @ticket = build_ticket_and_details
    rs = @current_user.route_stocks.current_day.last

    if @ticket.save_and_update_route_stock(rs)
      response = { status: :completed, data: @ticket.as_json() }
      render json: JSON.pretty_generate(response)
    else
      render_unprocessable_error(@ticket)
    end
  end

  def destroy
    render_404
  end

  private
    def build_ticket_and_details
      ticket = @current_user.tickets.build(ticket_params)
      params[:ticket][:details].values.each do |detail_params|
        ticket.details << ticket.build_detail(detail_params)
      end

      ticket
    end

end
