class Admin::ClientsController < ApplicationController
  before_action :load_clients, only: :index
  load_and_authorize_resource

  def index
  end

  def show
  end

  private
    def load_clients
      @pagy, @clients = pagy(
        Client.active.includes(:user, city: :state)
      )
    end

end
