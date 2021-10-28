Rails.application.routes.draw do
  # devise_for :users
  namespace :v1, defaults: {format: :json} do
    resources :accounts, only: [:create, :update] do
      resources :contacts
    end
    resources :sessions, only: [:create, :destroy]
    resources :users, only: [:create]
  end
end
