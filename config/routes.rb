Rails.application.routes.draw do
  resources :users
  root "articles#new" #追加
  resources :articles
end