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
    post 'dashboard/export_excel', to: 'pages#export_programs_info_excel', as: 'export_programs_info_excel'
    post 'dashboard/export_pdf', to: 'pages#export_programs_info_pdf', as: 'export_programs_info_pdf', defaults: { format: 'pdf' }

    resources :faqs

    resources :posts

    resources :programs, only: [:index, :show, :new, :edit, :create, :update, :destroy] do
      get ':id/all_steps', to: 'programs#steps', as: 'program_all_steps', on: :collection, defaults: { format: 'json' }
      resources :steps, only: [:index, :show, :new, :edit, :create, :update, :destroy]
    end


    resources :events do
      post 'participate', on: :member   # Keep this as it is for registration
      delete 'unregister', on: :member  # Change to delete for unregistration
      post 'export_excel', on: :member
      post 'export_pdf', on: :member
    end

    post 'programs/:program_id/apply', to: 'users_programs_steps#apply_to_program', as: 'apply_to_program'
    post 'programs/:program_id/answer_questionnaire', to: 'users_programs_steps#answer_questionnaire', as: 'answer_questionnaire'
    post 'programs/:program_id/steps/:id/apply_for_next', to: 'users_programs_steps#apply_for_next_step', as: 'apply_for_next_step'
    get 'programs/:program_id/cancel_apply', to: 'users_programs_steps#cancel_apply_to_program', as: 'cancel_apply_to_program'
     #Apply to Program
    get 'programs/:program_id/apply', to: 'users_programs_steps#apply', as: 'apply'
     # Questionnaire
    get 'programs/:program_id/questionnaire', to: 'users_programs_steps#questionnaire', as: 'questionnaire'
     #Tabulator selector steps  response
    get 'steps/:program_id/table_data', to: 'steps#table_data', as: 'steps_table_data'
    get 'steps/:program_id/get_steps_with_questionnaire', to: 'steps#get_steps_with_questionnaire', as: 'get_steps_with_questionnaire_by_program'
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

    # update evaluation status
    patch 'update_evaluation_status/:id', to: 'users_programs_steps#update_evaluation_status'

    patch 'users_programs_steps/approve/:id', to: 'users_programs_steps#approve', as: 'approve_candidate'
    patch 'users_programs_steps/disapprove/:id', to: 'users_programs_steps#disapprove', as: 'disapprove_candidate'
    # View candidates
    get 'users_programs_steps/candidate/:id', to: 'users_programs_steps#view_candidate', as: 'view_candidate'
    patch 'users_programs_steps/custom_weight/:answer_id', to: 'users_programs_steps#set_custom_weight'

    get 'step_questions/:program_id/new', to: 'step_questions#new', as: 'new_step_question'
    get 'step_questions/:program_id/edit/:id', to: 'step_questions#edit', as: 'edit_step_question'
    get 'step_questions/:program_id/clone', to: 'step_questions#clone', as: 'clone_questions'
    post 'step_questions/:program_id/clone', to: 'step_questions#save_clone', as: 'save_clone'
    post 'step_questions', to: 'step_questions#create', as: 'create_step_questions'
    patch 'step_questions/:id', to: 'step_questions#update', as: 'update_step_questions'
    delete 'step_questions/:id', to: 'step_questions#destroy', as: 'destroy_step_questions'
    # Preview
    get 'step_questions/:step_id/preview', to: 'step_questions#preview', as: 'preview'
  end
end
