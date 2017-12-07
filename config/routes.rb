Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :documents do
    collection do
      patch :batch_update  # route pour batch_update
    end
    resources :doctags, only: [:create, :destroy]
  end

  resources :tags, only: :create
end
