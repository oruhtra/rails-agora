Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :documents do
    resources :doctags, only: [:create, :destroy]
  end

  resources :tags, only: :create
end
