class StaticPagesController < ApplicationController
  skip_before_action :require_active_session
  skip_authorization_check

  def index
    render :index, layout: false
  end

  def states
    @states = State.all.order_by_name
    response = { status: :completed, data: @states.as_json(only: [:id, :name]) }
    render json: JSON.pretty_generate(response)
  end

  def cities
    @cities = City.where(state_id: params[:state_id]).order_by_name
    response = { status: :completed, data: @cities.as_json(only: [:id, :name]) }
    render json: JSON.pretty_generate(response)
  end
end
