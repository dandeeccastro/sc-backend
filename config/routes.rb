Rails.application.routes.draw do
  resources :notifications
  post '/register', to: 'user#create'
  post '/login', to: 'auth#login'

  get  '/events/:slug/talks', to: 'events#talks'

  get  '/events/:event_id/certificates/:user_id', to: 'certificates#list'
  post '/events/:event_id/certificates/:user_id', to: 'certificates#emit'

  get '/debug/:event_id/:user_id/event', to: 'certificates#event'
  get '/debug/:event_id/:user_id/staff', to: 'certificates#staff'
  get '/debug/:event_id/:user_id/talk/:talk_id', to: 'certificates#talk'

  resources :events, except: %i[show]
  get '/events/:slug', to: 'events#show'

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
