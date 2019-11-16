class Admin::TicketsController < ApplicationController
  before_action :load_tickets, only: :index
  load_and_authorize_resource

  def index
  end

  def show
  end

  private
    def load_tickets
      @pagy, @tickets = pagy(
        Ticket.recent.includes(:client, :user)
      )
    end

end
