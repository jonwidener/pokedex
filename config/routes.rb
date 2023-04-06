Rails.application.routes.draw do
  get 'pokemon/:id' => 'pokemon#show', as: 'pokemon'
  get 'pokedex/index'
  post 'pokedex/search'

  root "pokedex#index"
end
