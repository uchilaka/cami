class AccountsController < ApplicationController
  include MaybeAccountSpecific
  include LarCity::ProfileParameters

  # load_account %i[show edit update destroy], optional: true
  load_account :all, optional: true, id_keys: %i[account_id id]

  # before_action :set_account, only: %i[show edit update destroy]

  # GET /accounts or /accounts.json
  def index
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
    result = UpsertAccountWorkflow.call(
      account_params: create_account_params,
      profile_params: create_profile_params
    )
    @account = result.account

    respond_to do |format|
      if result.success?
        format.html { redirect_to account_url(@account), notice: 'Account was successfully created.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json do
          render status: :unprocessable_content, json: { account: result.account&.errors }
        end
      end
    end
  end

  # PATCH/PUT /accounts/1 or /accounts/1.json
  def update
    result = UpsertAccountWorkflow.call(
      account:, current_user:,
      account_params: update_params[:account],
      profile_params: update_params[:profile]
    )
    @account = result.account
    respond_to do |format|
      if result.success?
        format.html { redirect_to account_url(@account), notice: 'Account was successfully created.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json do
          render status: :unprocessable_content, json: { account: result.account&.errors }
        end
      end
    end
  end

  # DELETE /accounts/1 or /accounts/1.json
  def destroy
    @account.destroy!

    respond_to do |format|
      format.html { redirect_to accounts_path, status: :see_other, notice: "Account was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.

  # TODO: Refactor the :create action to expect :account_params
  #   and :profile_params discretely from the frontend
  def create_account_params
    params
      .require(:account)
      .permit(:slug, :display_name, :email, :readme, :status, :tax_id, :type)
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
    base_keys = %i[display_name readme status tax_id]
    if Current.user&.admin?
      base_keys + %i[email]
    else
      base_keys
    end
  end
end
