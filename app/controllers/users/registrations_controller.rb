# frozen_string_literal: true

module Users
  # Kind of ancient, but hopefully still useful: https://gist.github.com/kinopyo/2343176
  class RegistrationsController < Devise::RegistrationsController
    # include ApplicationHelper
    #
    # before_action :configure_sign_up_params, only: [:create]
    # before_action :configure_account_update_params, only: [:update]
    #
    # # GET /resource/sign_up
    # def new
    #   super
    # end
    #
    # # POST /resource
    # def create
    #   super
    # end
    #
    # # GET /resource/edit
    # def edit
    #   super
    # end
    #
    # # PUT /resource
    # def update
    #   super
    # end
    #
    # # DELETE /resource
    # def destroy
    #   super
    # end
    #
    # # GET /resource/cancel
    # def cancel
    #   super
    # end
    #
    # protected
    #
    # # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_up_params
    #   devise_parameter_sanitizer.permit(:sign_up, keys: %i[given_name family_name nickname])
    # end
    #
    # # If you have extra params to permit, append them to the sanitizer.
    # def configure_account_update_params
    #   devise_parameter_sanitizer.permit(:account_update, keys: %i[given_name family_name nickname])
    # end
    #
    # # The path used after sign up.
    # def after_sign_up_path_for(_resource)
    #   root_path
    # end
    #
    # # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(_resource)
    #   root_path
    # end
    #
    # # The path used after sign up for inactive accounts.
    # def after_update_path_for(_resource)
    #   root_path
    # end
  end
end
