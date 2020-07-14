Rails.application.routes.draw do
  root "application#home"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  namespace :admin do
    get '/', to: "application#home"
  end
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users
end
