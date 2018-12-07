Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :documents, only: [ :index, :show, :create]
    end
  end

  root to: 'api/v1/documents#index', defaults: { format: :json }
end
