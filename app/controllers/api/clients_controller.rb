class Api::ClientsController < ApiController
  def index
    @clients = @current_user.clients.active

    response = { status: :completed, data: @clients.to_json }
    render json: JSON.pretty_generate(response)
  end

  def show
    @client = Client.find(params[:id])

    response = { status: :completed, data: @client.to_json }
    render json: JSON.pretty_generate(response)
  end

  def create
    @client = @current_user.clients.build(client_params)
    if @client.save
      response = { status: :completed, data: @client.to_json }
      render json: JSON.pretty_generate(response)
    else
      render_unprocessable_error(@client)
    end
  end

  def update
    @client = @current_user.clients.find(params[:id])
    if @client.update_attributes(client_params)
      response = { status: :completed, data: @client.to_json }
      render json: JSON.pretty_generate(response)
    else
      render_unprocessable_error(@client)
    end
  end

  def destroy
    @client = @current_user.clients.find(params[:id])
    if @client.destroy
      response = { status: :completed, data: @client.to_json }
      render json: JSON.pretty_generate(response)
    else
      render_unprocessable_error(@client)
    end
  end

  private
    def client_params
      params.require(:client).permit(
        :city_id,
        :name,
        :telephone,
        :address,
        :colony,
        :zc,
        :lat,
        :lng,
        :billing_data
      )
    end
end
