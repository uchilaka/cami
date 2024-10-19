# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :set_account, only: %i[show edit update destroy]

  attr_reader :account

  # GET /accounts
  def index
    # TODO: Limit the accounts returned to those the customer
    #   has access through via a policy (Pundit)
    @accounts = Account.all
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
    profile_params = create_account_params.slice(:phone)
    @account = Account.new(create_account_params.except(*profile_params.keys))

    respond_to do |format|
      if @account.save
        format.html { redirect_to account_url(@account), notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1 or /accounts/1.json
  def update
    respond_to do |format|
      if account.update(account_params)
        format.html { redirect_to account, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: account.errors, status: :unprocessable_entity }
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
    @account = Account.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to accounts_path
  end

  # Only allow a list of trusted parameters through.
  def create_account_params
    params.require(:account).permit(:slug, :display_name, :readme, :status, :tax_id, :email, :phone, :type)
  end

  def account_params
    common_param_keys = %i[display_name readme status]
    params_filter =
      case parameter_key
      when :business
        common_param_keys + %i[tax_id email phone]
      when :individual
        common_param_keys
      else
        common_param_keys + %i[tax_id]
      end
    params.require(parameter_key).permit(*params_filter)
  end

  def parameter_key
    return :business if account.is_a?(Business)
    return :individual if account.is_a?(Individual)

    :account
  end
end
