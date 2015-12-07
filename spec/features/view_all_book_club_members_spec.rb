require 'spec_helper'

feature 'book club member directory' do
  scenario "view list of all book club members" do
    member = FactoryGirl.create(:member)
    visit '/members'

    expect(page).to have_content("All Book Club Members")
    expect(page).to have_content member.first_name
    expect(page).to have_content member.email
  end
end
