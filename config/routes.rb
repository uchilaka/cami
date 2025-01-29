# frozen_string_literal: true

require_relative '../lib/admin_scope_constraint'
require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  resources :invoices, except: %i[destroy] do
    collection do
      post :search
    end
  end

  resources :accounts, except: %i[destroy] do
    resources :invoices, except: %i[destroy]
  end

  devise_for :users,
             controllers: {
               sessions: 'users/passwordless',
               passwords: 'users/passwords',
               registrations: 'users/registrations',
               confirmations: 'users/confirmations',
               unlocks: 'users/unlocks',
               omniauth_callbacks: 'users/omniauth/callbacks'
             }

  devise_scope :user do
    get 'users/fallback/sign_in', as: :new_user_fallback_session, to: 'users/sessions#new'
    post 'users/fallback/sign_in', as: :user_fallback_session, to: 'users/sessions#create'
    delete 'users/fallback/sign_out', as: :destroy_user_fallback_session, to: 'users/sessions#destroy'
  end

  scope :admin, as: :admin do
    constraints AdminScopeConstraint.new do
      # Setting up sidekiq web: https://github.com/sidekiq/sidekiq/wiki/Monitoring#web-ui
      mount Sidekiq::Web => '/sidekiq'
    end
  end

  # get 'pages/services'

  match 'app/about', to: 'pages#app', via: :get
  match 'app/home', to: 'pages#app', via: :get
  match 'app/*path', to: 'pages#app', via: :get

  root to: 'pages#app'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest

  namespace :api do
    resources :features, only: %i[index], defaults: { format: :json }
  end

  draw :flipper

  match '*unmatched', to: 'errors#emit_routing_exception', via: :all
end
