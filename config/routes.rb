Rails.application.routes.draw do
  root "slots#index"

  resources :slots, except: [:index, :edit, :update]

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
