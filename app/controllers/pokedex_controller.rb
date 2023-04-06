class PokedexController < ApplicationController
  def index
    @pokelist = (0..150).map { || '----------' }
    all_pokemon = Pokemon.where(:id => (1..150))
    all_pokemon.each do |pokemon|
      @pokelist[pokemon.id] = pokemon.name
    end
    @first_id = (params[:first_id] || 1).to_i
    @last_id = [150, @first_id + 17].min
  end

  def search
    pokesearch = params[:pokesearch].strip.downcase if params[:pokesearch]

    if pokesearch
      pokemon = Pokemon.find_by(name: pokesearch)
      unless pokemon and pokemon.flavor_text and pokemon.height
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
    search = CGI.escape(pokesearch)
    url = 'https://pokeapi.co/api/v2/pokemon/' + search
    species_url = 'https://pokeapi.co/api/v2/pokemon-species/' + search
    response = HTTParty.get url
    species_response = HTTParty.get species_url
    if response.code == 200 and species_response.code == 200
      pokedata = JSON.parse response.body
      species_data = JSON.parse species_response.body
      pokemon = Pokemon.new(
        name: pokedata['name'],
        main_sprite: pokedata['sprites']['front_default'],
        flavor_text: species_data['flavor_text_entries'].find { |el| el['version']['name'] == 'red' && el['language']['name'] == 'en' }['flavor_text'],
        genus: species_data['genera'].select { |el| el['language']['name'] == 'en' }[0]['genus'],
        height: pokedata['height'],
        weight: pokedata['weight']
      )
      pokemon.id = pokedata['id']
      begin
        pokemon.save
      rescue ActiveRecord::RecordNotUnique
        Pokemon.update(pokemon.id, :flavor_text => pokemon.flavor_text, :genus => pokemon.genus, :height => pokemon.height, :weight => pokemon.weight)
      end
    end
  end
end
