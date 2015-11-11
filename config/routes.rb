Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: "pages#front"

  get 'home', to: 'videos#index'
  get 'my_queue', to: 'queue_items#index'
  get 'register', to:'users#new'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'

  post 'update_queue', to: 'queue_items#update_queue'

  resources :categories, only: [:show]
  resources :queue_items, only: [:create, :destroy]
  resources :sessions, only: [:create]
  resources :users, only: [:create]

  resources :videos, only: [:show] do
    collection do
      get :search, to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end

end
