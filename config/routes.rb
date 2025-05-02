Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    get "dashboard", to: "dashboard#index"
  end

  get "dashboard", to: "dashboard#index"

  resources :transactions, only: [ :create, :index ]

  get "stocks", to: "stocks#index"

  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
