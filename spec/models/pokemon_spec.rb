require 'spec_helper'
RSpec.describe Pokemon do
  let(:pokemon) { FactoryGirl.create(:pokemon)}
  describe "#name" do
    it "should have a name" do
      expect(pokemon.name).to eq("Bulbasaur")
    end
  end

  describe "#poketype" do
    it "should have poketype" do
      expect(pokemon.poketype).to eq("Grass")
    end
  end

  describe "#ability" do
    it "should have a name" do
      expect(pokemon.ability).to eq("Overgrow")
    end
  end

  describe "#evolve" do
  let(:pokemon) { FactoryGirl.create(:evolved_pokemon)}
    it "should be evolved" do
      expect(pokemon.name).to eq("Ivysaur")
      expect(pokemon.age).to eq(3)
    end
  end

  describe '#pokemaster' do
    it "should have pokemaster" do
      expect(pokemon.pokemaster.name).to eq("Ash")
    end

    it "should have Brock as a pokemaster" do
      brock = FactoryGirl.create(:pokemaster, name: "Brock")
      brocks_pokemon = FactoryGirl.create(:pokemon, pokemaster: brock)
      expect(brocks_pokemon.pokemaster.name).to eq("Brock")
    end
  end
end
