Rails.application.routes.draw do

  root 'posts#index'

  devise_for :users
  
  resources :users, only: [:index, :show, :destroy, :create] do
    member do
      match 'send_friendship' => 'users#send_friendship', via: [:get]
      match 'reject' => 'users#reject', via: [:get]
      match 'accept' => 'users#accept', via: [:get]
      match 'unfriend' => 'users#unfriend', via: [:get]
      match 'cancel' => 'users#cancel', via: [:get]
    end
  end

  resources :posts, only: [:index, :create] do
    resources :comments, only: [:create]
    resources :likes, only: [:create, :destroy]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
