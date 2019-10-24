class Admin::UsersController < ApplicationController
  def index
    warehouse_id = current_user.warehouse_id
    @users = User.active.by_warehouse(warehouse_id)
      .non_admin.not(current_user.id).order_by_name
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      redirect_to [:admin, @user], flash: {success: t(".success", user: @user)}
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    deny_access and return unless can_edit?(@user)

    @user.email_confirmation = @user.email
  end

  def update
    @user = User.find(params[:id])
    deny_access and return unless can_edit?(@user)

    if @user.update_attributes user_params
      redirect_to [:admin, @user], flash: { success: t(".success", user: @user) }
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = t(".success", user: @user, url: restore_admin_user_path(@user))
    else
      flash[:info] = t(".failure", user: @user)
    end
    redirect_to admin_users_path
  end

  def restore
    @user = User.find(params[:id])
    if @user.restore!
      flash[:success] = t(".success", user: @user)
      redirect_to [:admin, @user]
    else
      flash[:info] = t(".failure", user: @user)
      redirect_to admin_users_path
    end
  end

  private
    def user_params
      params.require(:user).permit(
        :name, 
        :cellphone, 
        :email, 
        :email_confirmation, 
        :password, 
        :password_confirmation, 
        :roles, 
        :warehouse_id, 
        :avatar
      )
    end

    def can_edit?(user)
      if user.role?(:admin) # target is an admin
        return false unless current_user? user # editing himself? ok!
      elsif current_user? user # non admin editing himself? nope!
        return false
      end

      return true
    end
end
