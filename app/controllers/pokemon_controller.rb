class PokemonController < ApplicationController
  def show
    begin
      @pokemon = Pokemon.find params[:id]
    rescue ActiveRecord::RecordNotFound
    end
  end
end
