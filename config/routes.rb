Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :products, only: [ :index, :show, :create]
    end
  end

  root to: 'api/v1/contracts#index', defaults: { format: :json }
end
