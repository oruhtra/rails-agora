Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :documents do
    collection do
      patch :batch_update  # route pour batch_update
      get :unselect_docs
      get :downloadzip
      get :scrap_documents
    end
    member do
      get :download #route to download
    end

    resources :doctags, only: [:create, :destroy]
  end

  resources :tags, only: :create

  resources :user_services, only: [:new, :create, :destroy]

  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

end
