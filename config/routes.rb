Rails.application.routes.draw do
  post '/register', to: 'user#create'
  post '/login', to: 'auth#login'

  get  '/events/:slug/talks', to: 'events#talks'

  get '/events/:event_id/notifications', to: 'notifications#event'
  get '/talks/:talk_id/notifications', to: 'notifications#talk'

  get  '/events/:event_id/certificates/:user_id', to: 'certificates#list'
  post '/events/:event_id/certificates/:user_id', to: 'certificates#emit'

  get '/events/:event_id/talks/:talk_id/vacancies', to: 'vacancies#talk'
  get '/user/:user_id/vacancies', to: 'vacancies#user'

  resources :merches
  resources :reservations, except: %i[update]
  resources :talks
  resources :materials
  resources :notifications
  resources :vacancies, except: :index

  resources :events, except: %i[show]
  get '/events/:slug', to: 'events#show'

  resources :user, except: %i[create]
  resources :talks

  resources :teams
  resources :user, except: %i[create]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
