class ApiController < ActionController::API
  include ApplicationHelper
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound do |e|
    render_404
  end

  rescue_from ActionController::UnknownFormat do |e|
    render_404
  end

  rescue_from ActionController::ParameterMissing do |e|
    render_parameter_validation_error(e.message)
  end

  def authenticate_user!
    auth_token = request.headers["Authorization"]
    render_auth_error and return unless auth_token.present?
      
    @current_user ||= authenticate_user(auth_token: auth_token)
    unless @current_user and @current_user.role?(:delivery_man)
      render_auth_error and return
    end
  end

  private
    def render_404
      head :not_found
      return true
    end
    
    def render_parameter_validation_error(msg)
      response = { status: "error", message: "parameter_validation_error", details: msg }
      render status: 422, json: JSON.pretty_generate(response)
      return true
    end

    def render_unprocessable_error(obj)
      response = { status: "error", message: :unprocessable, errors: obj.errors.full_messages }
      render json: JSON.pretty_generate(response)
      return true
    end

    def render_auth_error
      render status: 401
      return true
    end

end
