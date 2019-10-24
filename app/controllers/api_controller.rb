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
    render_auth_error and return unless auth_token.present?
      
    @current_user ||= authenticate_user(auth_token: auth_token)
    unless @current_user and @current_user.role?(:delivery_man)
      render_auth_error and return
    end
  end

  private
    def render_404
      head :not_found
    end

    def render_auth_error
      render status: 401
      return true
    end

end
