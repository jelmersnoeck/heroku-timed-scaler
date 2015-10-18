Rails.application.routes.draw do
  root "slots#index"

  resources :slots, except: [:index]
end
