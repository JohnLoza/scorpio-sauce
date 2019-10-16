class Api::SessionsController < ApiController
  skip_before_action :authenticate_user!

  def create
    email = params[:email]
    password = params[:password]

    user = User.find_by(email: email)
    unless user and user.authenticate(password)
      render_auth_error and return 
    end

    token = JsonWebToken.encode(user_id: user.id)
    response = { status: "completed", data: { authentication_token: token } }
    render json: JSON.pretty_generate(response)
  end
end
