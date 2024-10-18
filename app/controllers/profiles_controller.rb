# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :set_account
  before_action :set_metadata_profile, only: %i[show edit update destroy]

  attr_reader :account, :metadata_profile

  # GET /profiles
  def index
    @metadata_profiles = Metadata::Profile.all
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
    @metadata_profile.destroy
    respond_to do |format|
      format.html { redirect_to _metadata_profiles_url, notice: 'Profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_metadata_profile
    @metadata_profile = Metadata::Profile.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to accounts_path
  end

  # Only allow a list of trusted parameters through.
  def metadata_profile_params
    params.fetch(:metadata_profile, {})
  end

  def set_account
    @account = Account.find(params[:account_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to accounts_path
  end
end
