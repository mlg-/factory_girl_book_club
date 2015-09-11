require 'spec_helper'

RSpec.describe Pokemaster do
  let(:pokemaster) { FactoryGirl.create(:pokemaster) }
  describe "#name" do
    it "should have a name" do
      expect(pokemaster.name).to eq("Ash")
    end
  end

  describe "#age" do
    it "should have a name" do
      expect(pokemaster.age).to eq(14)
    end
  end
end
