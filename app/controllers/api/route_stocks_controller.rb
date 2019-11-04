class Api::RouteStocksController < ApiController
  def show
    @route_stock = @current_user.route_stocks.current_day.last
    render_404 and return unless @route_stock

    response = { status: :completed, data: @route_stock.products }
    render json: JSON.pretty_generate(response)
  end
end
