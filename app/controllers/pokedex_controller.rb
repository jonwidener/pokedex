class PokedexController < ApplicationController
  def index
    @pokelist = []
    (1..150).each do |id|
      @pokelist[id] = '----------'
      begin
        pokemon = Pokemon.find(id)
        @pokelist[pokemon.id] = pokemon.name if pokemon
      rescue ActiveRecord::RecordNotFound
      end
    end
  end

  def search
    pokesearch = params[:pokesearch].strip.downcase if params[:pokesearch]

    if pokesearch
      pokemon = Pokemon.find_by(name: pokesearch)
      unless pokemon
        url = 'https://pokeapi.co/api/v2/pokemon/' + pokesearch
        response = HTTParty.get url
        if response.code == 200
          pokedata = JSON.parse response.body

          pokemon = Pokemon.new name: pokedata['name'], main_sprite: pokedata['sprites']['front_default']
          pokemon.id = pokedata['id']
          pokemon.save
        end
      end

      redirect_to '/pokemon/' + pokemon.id.to_s
      return
    end

    redirect_to root_path
  end
end
