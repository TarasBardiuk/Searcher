Rails.application.routes.draw do
  root 'static_pages#home'

  match '/search', to: 'static_pages#search', as: :search, via: [:get, :post]
end
