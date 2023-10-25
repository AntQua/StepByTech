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

    resources :events

     # Temporary debugging route
    #post '/programs/:program_id/steps/:id', to: 'steps#update'

    resources :programs, only: [:index, :show, :new, :edit, :create, :update, :destroy] do
      resources :steps, only: [:show, :new, :edit, :create, :update, :destroy]
    end

    post 'programs/:program_id/apply', to: 'users_programs_steps#apply_to_program', as: 'apply_to_program'
    post 'programs/:program_id/steps/:id/apply_for_next', to: 'users_programs_steps#apply_for_next_step', as: 'apply_for_next_step'
  end
end
