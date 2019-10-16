class Api::UsersController < ApiController
  def index
    users = User.non_admin.active.order_by_name
    response = { status: "completed", data: users.to_json}

    render json: JSON.pretty_generate(response)
  end
end
