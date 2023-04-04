class PokemonController < ApplicationController
  def show
    begin
      @pokemon = Pokemon.find params[:id]
      unless @pokemon.flavor_text
        PokedexController.update_pokemon @pokemon.name
        @pokemon = Pokemon.find params[:id]
      end
    rescue ActiveRecord::RecordNotFound
    end
  end
end
