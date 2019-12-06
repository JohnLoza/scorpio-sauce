class Api::ClientsController < ApiController
  def index
    @pagy, @clients = pagy(
      @current_user.clients.active.order_by_name.includes(city: :state)
    )

    response = {
      status: :completed,
      data: @clients.as_json(),
      pagy: pagy_metadata(@pagy)
    }

    render json: JSON.pretty_generate(response)
  end

  def show
    @client = @current_user.clients.active.find(params[:id])

    response = { status: :completed, data: @client.as_json()}
    render json: JSON.pretty_generate(response)
  end

  def create
    @client = @current_user.clients.build(client_params)
    if @client.save
      response = { status: :completed, data: @client.as_json()}
      render json: JSON.pretty_generate(response)
    else
      render_unprocessable_error(@client)
    end
  end

  def update
    @client = @current_user.clients.active.find(params[:id])
    if @client.update_attributes(client_params)
      response = { status: :completed, data: @client.as_json() }
      render json: JSON.pretty_generate(response)
    else
      render_unprocessable_error(@client)
    end
  end

  def destroy
    @client = @current_user.clients.active.find(params[:id])
    if @client.destroy
      response = { status: :completed }
      render json: JSON.pretty_generate(response)
    else
      render_unprocessable_error(@client)
    end
  end

  def locations
    @clients = @current_user.clients.active

    response = {
      status: :completed,
      data: @clients.as_json(only: [:name, :address, :lat, :lng])
    }
    render json: JSON.pretty_generate(response)
  end

  private
    def client_params
      params.require(:client).permit(
        :city_id, :name, :telephone, :address,
        :colony, :zc, :lat, :lng,
        billing_data: {}
      )
    end
end
