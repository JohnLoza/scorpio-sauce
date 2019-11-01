class Admin::UsersController < ApplicationController
  before_action :load_users, only: :index
  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
  end

  def create
    if @user.save
      redirect_to [:admin, @user], flash: {success: t(".success", user: @user)}
    else
      render :new
    end
  end

  def edit
    @user.email_confirmation = @user.email
  end

  def update
    if @user.update_attributes user_params
      redirect_to [:admin, @user], flash: { success: t(".success", user: @user) }
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t(".success", user: @user, url: restore_admin_user_path(@user))
    else
      flash[:info] = t(".failure", user: @user)
    end
    redirect_to admin_users_path
  end

  def restore
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
        :name, :cellphone, :email, :email_confirmation,
        :password, :password_confirmation, :role,
        :warehouse_id, :avatar
      )
    end

    def load_users
      warehouse_id = filter_params(require: :warehouse_id, default_value: current_user.warehouse_id)

      @pagy, @users = pagy(
        User.active.by_warehouse(warehouse_id)
          .by_role(filter_params(require: :role))
          .non_admin.not(current_user.id).order_by_name
          .with_attached_avatar
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
