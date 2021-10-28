module V1
  class AccountsController < ApplicationController
    def create
      @account = current_user.accounts.build(account_params)

      if @account.save
        render :create, status: :created
      else
        head(:unprocessable_entity)
      end
    end

    def update
      @account = current_user.accounts.friendly.find(:id)

      if @account.update(account_params)
        render :update
      else
        head(:unprocessable_entity)
      end
    end

    private

    def account_params
      params.require(:accounts).permit(:name)
    end
  end
end