# frozen_string_literal: true

require 'sidekiq/web'

Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_interslice_session'

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get 'up' => 'rails/health#show', as: :rails_health_check

  scope '/v1' do
    resources :people, only: [:create, :show, :update, :destroy] do
      get :search, on: :collection
      get :genders, on: :collection
      get :marital_statuses, on: :collection
      post :attach, on: :member
      delete :detach, on: :member
      get :download_pdf, on: :collection
      get :download_csv, on: :collection
    end

    resources :job_roles, only: [:index]
    resources :workspaces, only: [:index]
  end

  # Defines the root path route ("/")
  # root "posts#index"
  root to: proc { [200, {}, ['success']] }
  match '*path', to: proc { [404, {}, ['']] }, via: :all
end
