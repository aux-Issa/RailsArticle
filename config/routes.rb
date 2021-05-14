Rails.application.routes.draw do
  root 'home#index'
  get 'home/index'
  get 'home/show'
  resources :articles, only:[:create, :edit, :destroy, :new, :show, :update]
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
