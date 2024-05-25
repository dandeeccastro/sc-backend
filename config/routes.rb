Rails.application.routes.draw do
  post '/register', to: 'user#create'
  post '/login', to: 'auth#login'

  get '/events/:slug/talks', to: 'events#talks'

  resources :events
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
