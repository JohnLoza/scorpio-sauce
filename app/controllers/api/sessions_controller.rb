class Api::SessionsController < ApiController
  skip_before_action :authenticate_user!

  def create
    unless params[:session]
      render_auth_error and return
    end

    user = authenticate_user(params[:session])
    unless user and user.role?(:delivery_man)
      render_auth_error and return
    end

    token = JsonWebToken.encode(user_id: user.id)
    response = { status: :completed, data: { authentication_token: token } }
    render json: JSON.pretty_generate(response)
  end

end
