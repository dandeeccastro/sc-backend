Rails.application.routes.draw do
  # mount Rswag::Ui::Engine => '/api-docs'
  # mount Rswag::Api::Engine => '/api-docs'

  resources :user, except: %i[create]
  post '/register', to: 'user#create'

  get '/admin', to: 'user#is_admin'
  get '/me', to: 'user#me'

  post '/login', to: 'auth#login'
  post '/forget', to: 'auth#forget'
  post '/reset', to: 'auth#reset'

  resources :events, param: :slug, except: %i[update destroy] do
    get '/notifications/staff', to: 'notifications#staff'

    resources :merches 
    resources :notifications
    resources :reservations
    resources :category, except: %i[show]

    resources :talks, only: %i[index]
    get '/speakers', to: 'speaker#event'
    get '/users', to: 'user#event'
    get '/audit', to: 'audit#search'
  end

  get '/reservations', to: 'reservations#from_user'
  resources :reservations, only: %i[destroy]

  get '/events/:slug/staff', to: 'events#validate'

  get '/vacancies/me', to: 'vacancies#schedule'
  post '/participate', to: 'vacancies#participate'
  post '/validate', to: 'vacancies#validate'
  post '/enroll', to: 'vacancies#enroll'

  resources :vacancies, only: %i[destroy]

  get '/talks/:id/staff', to: 'talks#staff_show'
  get '/talks/:id/status', to: 'talks#status'
  post '/talks/:id/rate', to: 'talks#rate'

  get '/certificates', to: 'certificates#list'
  post '/certificates', to: 'certificates#emit'

  resources :talks, except: %i[index]

  get "/teams/:slug", to: 'teams#event'

  get '/debug/:slug', to: 'certificates#debug'

  resources :teams, except: %i[show]
  resources :events, only: %i[update destroy]

  put '/events/:slug/publish', to: 'events#publish'

  resources :speaker, except: %i[index show]
  resources :type, except: %i[show]
  resources :location, except: %i[show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
