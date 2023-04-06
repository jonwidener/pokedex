class AddHeightAndWeightToPokemon < ActiveRecord::Migration[7.0]
  def change
    add_column :pokemon, :height, :integer
    add_column :pokemon, :weight, :integer
  end
end
