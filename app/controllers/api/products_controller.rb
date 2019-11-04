class Api::ProductsController < ApiController
  def def index
    @products = Product.active.by_id(params[:id])

    response ={
      status: :completed,
      data: @products.as_json()
    }
    render json: JSON.pretty_generate(response)
  end

  def def show
    @product = Product.find(params[:id])

    response = { status: :completed, data: @product.as_json()}
    render json: JSON.pretty_generate(response)
  end
end
