require 'spec_helper'

feature 'pokemasters directory' do
  scenario "view list of pokemasters" do
    pokemaster = FactoryGirl.create(:pokemaster)
    visit '/pokemasters'

    expect(page).to have_content("Pokemasters Directory")
    expect(page).to have_content pokemaster.name
    expect(page).to have_content pokemaster.email
  end
end
