Rails.application.routes.draw do
  post '/register', to: 'user#create'
  post '/login', to: 'auth#login'

  resources :events
  resources :user, except: %i[create]
  resources :talks
  resources :teams
  resources :merches
  # resources :vacancies
  # resources :materials
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
