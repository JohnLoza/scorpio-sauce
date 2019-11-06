class Admin::ProductsController < ApplicationController
  before_action :load_products, only: :index
  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
  end

  def create
    if @product.save
      flash[:success] = t(".success", product: @product)
      redirect_to [:admin, @product]
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @product.update_attributes(product_params)
      flash[:success] = t(".success", product: @product)
      redirect_to [:admin, @product]
    else
      render 'edit'
    end
  end

  def destroy
    if @product.destroy
      flash[:success] = t(".success", product: @product, url: restore_admin_product_path(@product))
    else
      flash[:info] = t(".failure", product: @product)
    end
    redirect_to admin_products_path
  end

  def restore
    if @product.restore!
      flash[:success] = t(".success", product: @product)
      redirect_to [:admin, @product]
    else
      flash[:info] = t(".failure", product: @product)
      redirect_to admin_products_path
    end
  end

  private
    def product_params
      hash_params = params.require(:product).permit(
        :name, :main_image, :retail_price,
        :half_wholesale_price, :required_units_half_wholesale,
        :wholesale_price, :required_units_wholesale
      )

      if params[:box_names].nil? or params[:box_units].nil?
        hash_params[:boxes] = nil; return hash_params
      end

      boxes_array = Array.new
      params[:box_names].each.with_index do |box_name, indx|
        boxes_array << {name: params[:box_names][indx], units: params[:box_units][indx].to_i}
      end

      hash_params[:boxes] = boxes_array
      return hash_params
    end

    def load_products
      @pagy, @products = pagy(
        Product.active
      )
    end

end
