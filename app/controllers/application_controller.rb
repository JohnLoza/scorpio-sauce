class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionsHelper
  before_action :require_active_session

  rescue_from ActiveRecord::RecordNotFound do |e|
    render_404
  end

  rescue_from ActionController::UnknownFormat do |e|
    render_404
  end

  rescue_from ActionController::InvalidAuthenticityToken do |e|
    render_404
  end

  rescue_from ActionController::ParameterMissing do |e|
    render_parameter_validation_error(e.message)
  end

  def render_404
    respond_to do |format|
      format.html { render file: Rails.root.join("public", "404"), layout: false, status: 404 }
      format.any { head :not_found }
    end
  end

  private
    def require_active_session
      unless logged_in?
        store_location
        redirect_to new_session_path
      end
    end

    def deny_access
      redirect_to admin_home_path, flash: { info: t("labels.access_denied") }
      return true
    end

    def render_parameter_validation_error(msg)
      response = { status: "error", message: "parameter_validation_error", details: msg }
      render status: 422, json: JSON.pretty_generate(response)
      return true
    end
end
