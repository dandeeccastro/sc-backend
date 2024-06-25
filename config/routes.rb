Rails.application.routes.draw do
  post '/register', to: 'user#create'
  post '/login', to: 'auth#login'

  resources :events, param: :slug, except: %i[show] do
    resources :merches 
  end

  get '/events/:slug', to: 'events#show'
  get  '/events/:event_id/certificates/:user_id', to: 'certificates#list'
  post '/events/:event_id/certificates/:user_id', to: 'certificates#emit'

  post '/participate', to: 'vacancies#participate'
  post '/validate', to: 'vacancies#validate'

  get '/vacancies/me', to: 'vacancies#schedule'

  post '/talks/:id/rate', to: 'talks#rate'
  get '/talks/:id/status', to: 'talks#status'

  resources :notifications
  resources :user, except: %i[create]
  resources :talks
  resources :teams
  resources :vacancies, except: %i[index]
  resources :materials
  resources :reservations, except: %i[update]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
