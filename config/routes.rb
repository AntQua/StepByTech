Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

   get '/programsdetail/:id', to: 'programs#detail', as: 'programdetail'

   get '/generalfaqs', to: 'faqs#general', as: 'generalfaqs'

   get '/general_galeria', to: 'posts#general', as: 'general_galeria'

   get '/contactos', to: 'pages#contacts', as: 'contacts'


  authenticate :user do
    get 'user/profile', to: 'users#profile'
    get 'user/settings', to: 'users#settings'
    patch 'user/settings', to: 'users#update_settings'

    get 'dashboard', to: 'pages#dashboard'

    resources :faqs

    resources :posts

    resources :programs, only: [:index, :show, :new, :edit, :create, :update, :destroy] do
      resources :steps, only: [:show, :new, :edit, :create, :update, :destroy]
    end

    resources :events do
      post 'participate', on: :member
      post 'unregister', on: :member
    end

    post 'programs/:program_id/apply', to: 'users_programs_steps#apply_to_program', as: 'apply_to_program'
    post 'programs/:program_id/steps/:id/apply_for_next', to: 'users_programs_steps#apply_for_next_step', as: 'apply_for_next_step'

     #Apply to Program
    get 'programs/:program_id/apply', to: 'users_programs_steps#apply', as: 'apply'
     #Tabulator selector steps  response
    get 'steps/:program_id/table_data', to: 'steps#table_data', as: 'steps_table_data'
     #Tabulator candidates response
    get 'users_programs_steps/:program_id/table_data', to: 'users_programs_steps#table_data', as: 'candidates_table_data'
     #Tabulator attributes response
    get 'program_attributes/:program_id/table_data', to: 'program_attributes#table_data', as: 'attributes_table_data'
     #Tabulator questions response
    get 'step_questions/:program_id/table_data', to: 'step_questions#table_data', as: 'step_questions_table_data'
     #Tabulator questions options response
    get 'step_question_options/:program_id/table_data', to: 'step_question_options#table_data', as: 'step_question_options_table_data'
     #Tabulator save step question options
    patch 'step_question_options/:program_id/save', to: 'step_question_options#save', as: 'save_step_question_options'
     #Tabulator save step questions
    patch 'step_questions/:program_id/save', to: 'step_questions#save', as: 'save_step_questions'
     #Tabulator save attributes
    patch 'program_attributes/:program_id/save', to: 'program_attributes#save', as: 'save_attribute'
     #Tabulator update step candidate
    patch 'users_programs_steps/:program_id/update', to: 'users_programs_steps#update_step_candidate', as: 'update_step_candidate'



    get 'step_questions/:program_id/new', to: 'step_questions#new', as: 'new_step_question'
    post 'step_questions', to: 'step_questions#create', as: 'step_questions'
    # post 'step_questions/new', to: 'step_questions#'
  end
end
