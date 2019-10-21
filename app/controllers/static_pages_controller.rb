class StaticPagesController < ApplicationController
  skip_before_action :require_active_session
  
  def index
    render :index, layout: false
  end

  def cities
    @cities = City.where(state_id: params[:state_id]).order_by_name

    respond_to do |format|
      format.json{ render json: @cities.as_json(only: [:id, :name]), status: 200 }
      format.any{ head :not_found }
    end
  end
end
