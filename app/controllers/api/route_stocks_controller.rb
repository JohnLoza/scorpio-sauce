class Api::RouteStocksController < ApiController
  def show
    @route_stock = @current_user.route_stocks.current_day.last
    render_404 and return unless @route_stock

    route_stock_products = @route_stock.products
    product_ids = route_stock_products.map{ |rsp| rsp["product_id"] }

    products = Product.where(id: product_ids).to_a
    route_stock_products.each.with_index do |rsp, indx|
      current_product = products.select{ |p| p.id == rsp["product_id"].to_i }
      route_stock_products[indx]["product_name"] = current_product[0].name
    end

    response = { status: :completed, data: route_stock_products }
    render json: JSON.pretty_generate(response)
  end
end
