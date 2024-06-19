Rails.application.routes.draw do
  post '/register', to: 'user#create'
  post '/login', to: 'auth#login'

  resources :events, except: %i[show]
  get '/events/:slug', to: 'events#show'
  get  '/events/:event_id/certificates/:user_id', to: 'certificates#list'
  post '/events/:event_id/certificates/:user_id', to: 'certificates#emit'

  post '/participate', to: 'vacancies#participate'
  post '/validate', to: 'vacancies#validate'

  resources :notifications
  resources :user, except: %i[create]
  resources :talks
  resources :teams
  resources :merches
  resources :vacancies
  resources :materials
  resources :reservations, except: %i[update]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
