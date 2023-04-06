class PokemonController < ApplicationController
  helper_method :height, :weight
  def show
    begin
      @pokemon = Pokemon.find params[:id]
      unless @pokemon.flavor_text and @pokemon.height
        PokedexController.update_pokemon @pokemon.name
        @pokemon = Pokemon.find params[:id]
      end
    rescue ActiveRecord::RecordNotFound
      @pokemon = Pokemon.new(name: '???', genus: '??? Pokémon', main_sprite: '', flavor_text: '???', height: 0, weight: 0)
    end
    puts response.inspect
  end

  def height
    return '???' if @pokemon.height == 0
    feet = @pokemon.height * 0.32808399
    inches = (feet.modulo(1) * 12).floor
    inches = inches == 0 ? 1 : inches
    feet = feet.floor
    "#{feet}'#{inches.to_s.rjust(2, '0')}\""
  end

  def weight
    return '???' if @pokemon.weight == 0
    pounds = @pokemon.weight * 0.22046226
    "#{pounds.round(1)}lb"
  end
end
