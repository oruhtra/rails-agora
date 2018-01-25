Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :documents do
    collection do
      get :unselect_docs
      get :downloadzip
      get :scrap_documents
      get :add_tags
      post :batch_update  # route pour batch_update
      delete :delete_batch  # route pour batch_update
      delete :destroy_prototypes
      post :batch_create_tag
      post :load_new_elements
    end
    member do
      get :download #route to download
    end

    resources :doctags, only: [:create, :destroy]
  end

  resources :tags, only: :create

  resources :user_services, only: [:new, :create, :destroy]

  resources :user_preferences, only: [:create]

  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount_griddler

end
