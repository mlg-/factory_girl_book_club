class CreatePokemons < ActiveRecord::Migration
  def change
    create_table :pokemons do |t|
      t.string :name, null: false
      t.string :ability
      t.string :poketype
      t.integer :strength
      t.integer :age
    end
  end
end
