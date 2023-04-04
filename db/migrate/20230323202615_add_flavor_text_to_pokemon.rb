class AddFlavorTextToPokemon < ActiveRecord::Migration[7.0]
  def change
    add_column :pokemon, :flavor_text, :string
  end
end
