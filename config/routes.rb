Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"

  resources :products, only: %i[index show new create]
  resources :locations, only: %i[index show new create]
  resources :inventory_items, only: %i[index show new create] do
    post :move, on: :member
  end
  resources :transfer_batches, only: %i[new create show] do
    post :commit, on: :member
  end
end
