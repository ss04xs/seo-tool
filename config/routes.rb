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
          get "all_queries" => "queries#all_queries", as: 'all_queries'
          get 'queries_by_domain', to: 'queries#queries_by_domain'
          get ':site_domain' => 'queries#site_queries', as: 'site_queries'
          post 'site_create' => 'queries#site_create', as: 'site_create'
        end
      end
      resources :sites
    end
  end
end
