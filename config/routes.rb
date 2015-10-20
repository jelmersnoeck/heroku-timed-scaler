Rails.application.routes.draw do
  root "slots#index"

  resources :slots, except: [:index, :edit, :update] do
    collection do
      get :import, to: 'slots#upload_csv'
      post :import
    end
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
