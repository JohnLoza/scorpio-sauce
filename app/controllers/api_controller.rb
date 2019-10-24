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
    auth_token = request.headers["Authorization"]
    render_missing_token_error and return unless auth_token.present?
      
    @current_user ||= authenticate_user(auth_token: auth_token)
    unless @current_user
      render_auth_error and return unless performed?
    end
  end

  def render_404
    head :not_found
  end

  private
    def deny_access
      response = { status: "error", message: "ACCESS_DENIED", code: 2010 }
      render status: 401, json: JSON.pretty_generate(response)
      return true
    end

    def render_auth_error
      response = { status: "error", message: "AUTHORIZATION_ERROR", code: 1010 }
      render status: 401, json: JSON.pretty_generate(response)
      return true
    end

    def render_missing_token_error
      response = { status: "error", message: "MISSING_AUTH_TOKEN", code: 1020 }
      render status: 401, json: JSON.pretty_generate(response)
      return true
    end
end
