class Admin::ClientsController < ApplicationController
  before_action :load_clients, only: :index
  load_and_authorize_resource

  def index
  end

  def show
  end

  private
    def load_clients
      name = filter_params(require: :name)
      u_id = filter_params(require: :user_id)
      @pagy, @clients = pagy(
        Client.active.by_name(name).by_user(u_id).includes(:user, city: :state)
      )
    end

end
