class Api::SessionsController < ApiController
  skip_before_action :authenticate_user!

  def create
    unless params[:session]
      render_missing_session_params and return
    end

    user = authenticate_user(params[:session])
    unless user and user.role?(:delivery_man)
      render_auth_error and return
    end

    token = JsonWebToken.encode(user_id: user.id)
    response = { status: "completed", data: { authentication_token: token } }
    render json: JSON.pretty_generate(response)
  end

  private
    def render_missing_session_params
      response = { status: "error", message: "MISSING_SESSION_PARAM", code: 1050 }
      render status: 401, json: JSON.pretty_generate(response)
      return true
    end
end
