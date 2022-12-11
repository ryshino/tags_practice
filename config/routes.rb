Rails.application.routes.draw do
  root "articles#new" #追加
  resources :articles
end
