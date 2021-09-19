Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'tops#index'
  get  '/tweets', to: 'tops#index',defalt: {format: 'json'}


  # resources :tops, only: :index do
  #   get :refresh, on: :collection
  # end


  namespace :api, {format: 'json'} do
    namespace :v1 do
      resources :users, only: [:index, :show] do
        get :refresh, on: :collection
      end
      resources :tweets, only: :index
    end
  end
end
