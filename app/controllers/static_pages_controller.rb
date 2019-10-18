class StaticPagesController < ApplicationController
  skip_before_action :require_active_session
  
  def index
    render :index, layout: false
  end
end
