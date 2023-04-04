Rails.application.routes.draw do
  get 'pokemon/:id' => 'pokemon#show', as: 'pokemon'
  get 'pokedex/index'
  post 'pokedex/search'

  resources :trainer

  root "pokedex#index"
end
