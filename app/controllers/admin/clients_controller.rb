class Admin::ClientsController < ApplicationController
  def index
    @pagy, @clients = pagy(
      Client.active.includes(:user, city: :state)
    )
  end

  def show
    @client = Client.find(params[:id])
  end
end
