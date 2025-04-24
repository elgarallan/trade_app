Rails.application.routes.draw do
  namespace :admin do
    get "dashboard", to: "dashboard#index"
  end

  get "dashboard", to: "dashboard#show"
  # get "home/index"
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
