Rails.application.routes.draw do
  resources :rank_checks
  resources :sites
  resources :queries
  resources :search_rankings
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace 'api' do
    namespace 'v1' do
      resources :posts_test
      resources :queries
    end
  end
end
