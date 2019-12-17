class Api::BankAccountsController < ApiController
  def index
    @bank_accounts = BankAccount.all

    response = { status: :completed, data: @bank_accounts.as_json() }
    render json: JSON.pretty_generate(response)
  end
end
