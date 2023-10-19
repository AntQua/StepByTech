Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  authenticate :user do
    get 'user/profile', to: 'users#profile'
    get 'user/settings', to: 'users#settings'
    patch 'user/settings', to: 'users#update_settings'

    get 'dashboard', to: 'pages#dashboard'

     # Temporary debugging route
    #post '/programs/:program_id/steps/:id', to: 'steps#update'

    resources :programs, only: [:index, :show, :new, :edit, :create, :update, :destroy] do
      resources :steps, only: [:show, :new, :edit, :create, :update, :destroy]
    end
  end
end
