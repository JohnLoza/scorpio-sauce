class Api::RouteStocksController < ApiController
  def show
    @route_stock = @current_user.route_stocks.current_day.last

    response { status: :completed, data: @route_stock.products }
    render json: JSON.pretty_generate(response)
  end
end
