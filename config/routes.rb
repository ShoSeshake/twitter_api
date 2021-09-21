Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'tops#index'
  get  '/tweets', to: 'tops#index',defalt: {format: 'json'}
  get  '/login', to: 'tops#index',defalt: {format: 'json'}
  get  '/oauth', to: 'tops#index',defalt: {format: 'json'}
  
  devise_for :users, :controllers => {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions',
  }

  namespace :api, {format: 'json'} do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'api/v1/auth/registrations',
        # omniauth_callbacks: 'api/v1/auth/omniauth_callbacks'
      }
      resources :users, only: [:index, :show] do
        get :refresh, on: :collection
        get :set_id, on: :collection
      end
      resources :tweets, only: :index
    end
  end
end
