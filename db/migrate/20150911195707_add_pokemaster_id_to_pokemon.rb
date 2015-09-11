class AddPokemasterIdToPokemon < ActiveRecord::Migration
  def change
    add_column :pokemons, :pokemaster_id, :integer 
  end
end
