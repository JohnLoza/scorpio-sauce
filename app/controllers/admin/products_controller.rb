class Admin::ProductsController < ApplicationController
  def index
    @products = Product.active
  end
  
  def show
    @product = Product.find(params[:id])
  end
  
  def new
    @product = Product.new
  end
  
  def create
    @product = Product.new(product_params)
    @product.build_boxes_json(params[:box_names], params[:box_units])
    if @product.save
      flash[:success] = t(".success", product: @product)
      redirect_to [:admin, @product]
    else
      render 'new'
    end
  end
  
  def edit
    @product = Product.find(params[:id])
  end
  
  def update
    @product = Product.find(params[:id])
    @product.build_boxes_json(params[:box_names], params[:box_units])
    if @product.update_attributes(product_params)
      flash[:success] = t(".success", product: @product)
      redirect_to [:admin, @product]
    else
      render 'edit'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      flash[:success] = t(".success", product: @product, url: restore_admin_product_path(@product))
    else
      flash[:info] = t(".failure", product: @product)
    end
    redirect_to admin_products_path
  end

  def restore
    @product = Product.find(params[:id])
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
      params.require(:product).permit(:name, :main_image, 
        :retail_price, :half_wholesale_price, :wholesale_price, 
        :required_units_half_wholesale, :required_units_wholesale)
    end
end
