Rails.application.routes.draw do
  root "application#home"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
end
