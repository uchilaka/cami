# frozen_string_literal: true

class AccountsController < ApplicationController
  include LarCity::ProfileParameters

  before_action :set_account, only: %i[show edit update destroy]

  attr_reader :account

  # GET /accounts
  def index
    # TODO: Limit the accounts returned to those the customer
    #   has access through via a policy (Pundit)
    @accounts = policy_scope(Account)
  end

  # GET /accounts/1 or /accounts/1.json
  def show; end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit; end

  # POST /accounts or /accounts.json
  def create
    result = CreateAccountWorkflow.call(params: create_account_params)
    @account = result.account

    respond_to do |format|
      if result.success?
        format.html { redirect_to account_url(@account), notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: {
            account: result.account&.errors,
            profile: result.profile&.errors
          }, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /accounts/1 or /accounts/1.json
  def update
    result =
      UpdateAccountWorkflow.call(
        account_params: update_params[:account],
        profile_params: update_params[:profile],
        account:
      )
    respond_to do |format|
      if result.success?
        format.html { redirect_to account_url(result.account), notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: account_url(result.account) }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: {
            account: result.account&.errors,
            profile: result.profile&.errors
          }, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /accounts/1 or /accounts/1.json
  def destroy
    account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = policy_scope(Account).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to accounts_path, notice: 'Account not found' }
      format.json { render json: { error: 'Account not found' }, status: :not_found }
    end
  end

  # TODO: Refactor the :create action to expect :account_params
  #   and :profile_params discretely from the frontend
  def create_account_params
    params
      .require(:account)
      .permit(:slug, :display_name, :readme, :status, :tax_id, :type, *create_profile_param_keys)
  end

  def create_profile_params
    params.permit(profile: create_profile_param_keys)[:profile]
  end

  def create_profile_param_keys
    (individual_profile_param_keys + business_profile_param_keys).uniq
  end

  def update_params
    params.permit(
      account: update_account_param_keys,
      profile: create_profile_param_keys
    )
  end

  def update_account_param_keys
    common_param_keys = %i[display_name readme status]
    case account
    when Business
      common_param_keys + %i[tax_id]
    else
      common_param_keys
    end
  end
end
