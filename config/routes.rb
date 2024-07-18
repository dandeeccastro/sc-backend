Rails.application.routes.draw do
  post '/register', to: 'user#create'
  post '/login', to: 'auth#login'

  resources :events, param: :slug do
    resources :merches 
    resources :notifications
    resources :reservations
    resources :category, only: %i[index create destroy]

    resources :talks, only: %i[index]

    get '/speakers', to: 'speaker#event'
    get '/users', to: 'user#event'
    get '/audit', to: 'audit#search'
  end

  get '/events/:slug/staff', to: 'events#validate'

  post '/participate', to: 'vacancies#participate'
  post '/validate', to: 'vacancies#validate'
  get '/vacancies/me', to: 'vacancies#schedule'

  resources :vacancies, only: %i[destroy]

  get '/talks/:id/staff', to: 'talks#staff_show'
  get '/talks/:id/status', to: 'talks#status'
  post '/talks/:id/rate', to: 'talks#rate'

  get '/certificates', to: 'certificates#list'
  post '/certificates', to: 'certificates#emit'

  resources :user, except: %i[create]
  resources :talks, except: %i[index]

  resources :teams
  resources :vacancies, except: %i[index]
  resources :materials

  resources :speaker
  resources :type, only: %i[index create]
  resources :location, only: %i[index]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
