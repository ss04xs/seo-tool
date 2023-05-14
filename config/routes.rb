Rails.application.routes.draw do
  resources :rank_checks
  resources :sites
  resources :search_rankings
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
