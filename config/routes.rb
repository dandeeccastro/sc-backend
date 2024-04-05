Rails.application.routes.draw do
  post '/register', to: 'user#create'
  post '/login', to: 'auth#login'

  resources :vacancies
  resources :materials
  resources :talks
  resources :merches
  resources :teams
  resources :events
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
