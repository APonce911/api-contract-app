Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :documents, only: [ :index, :show, :create, :update]
    end
  end
  get '/api/v1/documents/webhook', to: 'api/v1/documents#webhook'
  root to: '/', to: 'pages#home'
  # root to: 'api/v1/documents#index', defaults: { format: :json }
end
