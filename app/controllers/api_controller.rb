class ApiController < ActionController::API
  include ApplicationHelper
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound do |e|
    render_404
  end

  rescue_from ActionController::UnknownFormat do |e|
    render_404
  end

  def authenticate_user!
    @current_user ||= authorize_user(request.headers)
    unless @current_user
      render_auth_error and return unless performed?
    end
  end

  def render_auth_error
    response = { status: "error", message: "AUTHORIZATION_ERROR", code: 1010 }
    render status: 401, json: JSON.pretty_generate(response)
    return true
  end

  def deny_access
    response = { status: "error", message: "ACCESS_DENIED", code: 2010 }
    render status: 401, json: JSON.pretty_generate(response)
    return true
  end

  def render_404
    head :not_found
  end

  def search_params
    params[:s]
  end

  private
    def authorize_user(headers = {})
      render_missing_token_error and return unless headers["Authorization"].present?
      render_auth_token_expired and return unless decoded_auth_token(headers)

      User.find(decoded_auth_token(headers)[:user_id])
    end

    def decoded_auth_token(headers = {})
      JsonWebToken.decode(headers["Authorization"])
    end

    def render_missing_token_error
      response = { status: "error", message: "MISSING_AUTH_TOKEN", code: 1020 }
      render status: 401, json: JSON.pretty_generate(response)
      return true
    end

    def render_auth_token_expired
      response = { status: "error", message: "AUTH_TOKEN_EXPIRED", code: 1030 }
      render status: 401, json: JSON.pretty_generate(response)
      return true
    end
end
