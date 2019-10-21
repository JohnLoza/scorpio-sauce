class Admin::StockController < ApplicationController
  def index
    @stock = Stock.available
  end
  
end
