class Admin::BankAccountsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
  end

  def create
    if @bank_account.save
      flash[:success] = t(".success", account: @bank_account)
      redirect_to [:admin, @bank_account]
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @bank_account.update_attributes(bank_account_params)
      flash[:success] = t(".success", account: @bank_account)
      redirect_to [:admin, @bank_account]
    else
      render :edit
    end
  end

  def destroy
    if @bank_account.destroy
      flash[:success] = t(".success", account: @bank_account)
    else
      flash[:info] = t(".failure", account: @bank_account)
    end
    redirect_to admin_bank_accounts_path
  end

  private
    def bank_account_params
      params.require(:bank_account).permit(:bank_name, :owner, :number, :interbank_clabe, :rfc, :email)
    end

end
