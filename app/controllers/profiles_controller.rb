# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :set_account
  before_action :set_metadata_profile, only: %i[show edit update destroy]

  attr_accessor :account

  # GET /profiles
  def index
    @profiles =
      if account.is_a?(Business)
        Metadata::Business.where(account_id: params[:account_id])
      elsif account.is_a?(Individual)
        account.profiles
      else
        []
      end
  end

  # GET /profiles/1 or /profiles/1.json
  def show; end

  # GET /profiles/new
  def new
    @metadata_profile = Metadata::Profile.new
  end

  # GET /profiles/1/edit
  def edit; end

  # POST /profiles or /profiles.json
  def create
    @metadata_profile = Metadata::Profile.new(metadata_profile_params)

    respond_to do |format|
      if @metadata_profile.save
        format.html { redirect_to @metadata_profile, notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @metadata_profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @metadata_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1 or /profiles/1.json
  def update
    respond_to do |format|
      if @metadata_profile.update(metadata_profile_params)
        format.html { redirect_to @metadata_profile, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @metadata_profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @metadata_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1 or /profiles/1.json
  def destroy
    respond_to do |format|
      if @metadata_profile.destroy
        format.html { redirect_to account_profiles_path(@account), notice: 'Profile was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @metadata_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def metadata_profile_params
    params.fetch(:metadata_profile, {})
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_metadata_profile
    @metadata_profile =
      if account.is_a?(Business)
        Metadata::Business.find(params[:id])
      elsif account.is_a?(Individual)
        Metadata::Profile.find(params[:id])
      end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to account_profiles_path(@account), notice: 'Profile not found' }
      format.json { render json: { error: 'Profile not found' }, status: :not_found }
    end
  end

  def set_account
    @account = Account.find(params[:account_id])
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to profiles_path, notice: 'Account not found' }
      format.json { render json: { error: 'Account not found' }, status: :not_found }
    end
  end
end
