# frozen_string_literal: true

require_relative '../lib/admin_scope_constraint'
require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  resources :accounts, except: %i[index destroy]
  devise_for :users

  scope :admin, as: :admin do
    constraints AdminScopeConstraint.new do
      # Setting up sidekiq web: https://github.com/sidekiq/sidekiq/wiki/Monitoring#web-ui
      mount Sidekiq::Web => '/sidekiq'
    end
  end

  get 'pages/home'
  get 'pages/dashboard'

  # devise_scope :user do
  #   root to: 'pages#dashboard'
  # end

  root to: 'pages#home'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
