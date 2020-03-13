Rails.application.routes.draw do
  namespace :api do
    get 'orders/create'
  end
  namespace :api do
    resources :products, only: [:index]
  end
end