Rails.application.routes.draw do
  resources :contacts

  resources :accounts

  root to: 'visitors#index'
  devise_for :users
end
