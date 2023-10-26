Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

   get '/programsdetail/:id', to: 'programs#detail', as: 'programdetail'

   get '/generalfaqs', to: 'faqs#general', as: 'generalfaqs' #nova rota para a faqs na homepage

  authenticate :user do
    get 'user/profile', to: 'users#profile'
    get 'user/settings', to: 'users#settings'
    patch 'user/settings', to: 'users#update_settings'

    get 'dashboard', to: 'pages#dashboard'

    resources :events
    resources :faqs

     # Temporary debugging route
    #post '/programs/:program_id/steps/:id', to: 'steps#update'

    resources :programs, only: [:index, :show, :new, :edit, :create, :update, :destroy] do
      resources :steps, only: [:show, :new, :edit, :create, :update, :destroy]
    end
    post 'programs/:program_id/apply', to: 'users_programs_steps#apply_to_program', as: 'apply_to_program'
    post 'programs/:program_id/steps/:id/apply_for_next', to: 'users_programs_steps#apply_for_next_step', as: 'apply_for_next_step'
    get 'programs/:program_id/apply', to: 'users_programs_steps#apply', as: 'apply'

    get 'program_attributes/:program_id/table_data', to: 'program_attributes#table_data', as: 'table_data_attributes'
    patch 'program_attributes/save', to: 'program_attributes#save', as: 'save_attribute'
  end
end
