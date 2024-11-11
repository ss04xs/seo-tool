Rails.application.routes.draw do
  resources :rank_checks
  resources :sites
  resources :queries do
    collection do 
      get ':add' => 'queries#add', as: 'add'
      post 'query_create' => 'queries#query_create', as: 'query_create'
    end
  end
  resources :search_rankings
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace 'api' do
    namespace 'v1' do
      resources :posts_test
      resources :queries do 
        collection do 
          get ':site_domain' => 'queries#site_queries', as: 'site_queries'
          post 'site_create' => 'queries#site_create', as: 'site_create'
        end
      end
      resources :sites
    end
  end
end
