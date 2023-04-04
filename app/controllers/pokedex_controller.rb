class PokedexController < ApplicationController
  def index
    @pokelist = (1..150).map { || '----------' }
    all_pokemon = Pokemon.where(:id => (1..150))
    all_pokemon.each do |pokemon|
      @pokelist[pokemon.id] = pokemon.name
    end
  end

  def search
    pokesearch = CGI.escape(params[:pokesearch].strip.downcase) if params[:pokesearch]

    if pokesearch
      pokemon = Pokemon.find_by(name: pokesearch)
      unless pokemon and pokemon.flavor_text
        update_pokemon pokesearch
      end
      pokemon = Pokemon.find_by(name: pokesearch)
      if pokemon
        redirect_to '/pokemon/' + pokemon.id.to_s
        return
      end
    end

    redirect_to root_path
  end

  def update_pokemon pokemon
    PokedexController.update_pokemon pokemon
  end

  def self::update_pokemon pokesearch
    url = 'https://pokeapi.co/api/v2/pokemon/' + pokesearch
    species_url = 'https://pokeapi.co/api/v2/pokemon-species/' + pokesearch
    response = HTTParty.get url
    species_response = HTTParty.get species_url
    if response.code == 200 and species_response.code == 200
      pokedata = JSON.parse response.body
      species_data = JSON.parse species_response.body
      pokemon = Pokemon.new(
        name: pokedata['name'],
        main_sprite: pokedata['sprites']['front_default'],
        flavor_text: species_data['flavor_text_entries'].select { |el| el['version']['name'] == 'red' && el['language']['name'] == 'en' }[0]['flavor_text'],
        genus: species_data['genera'].select { |el| el['language']['name'] == 'en' }[0]['genus']
      )
      pokemon.id = pokedata['id']
      begin
        pokemon.save
      rescue ActiveRecord::RecordNotUnique
        Pokemon.update(pokemon.id, :flavor_text => pokemon.flavor_text, :genus => pokemon.genus)
      end
    end
  end
end
