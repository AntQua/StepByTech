Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  authenticate :user do
    get 'profile', to: 'users#profile'
    get 'settings', to: 'users#settings'
    get 'dashboard', to: 'pages#dashboard'
    #get 'programs', to: 'programs#index'

    # get 'events', to: 'events#index'
    # get 'resources', to: 'resources#index'
    resources :programs, only: [:index, :show, :new, :edit, :create, :update, :destroy]

  end
end
