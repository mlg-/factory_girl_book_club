require "spec_helper"

feature "book club member directory" do
  scenario "view all members" do
    emily_dickinson = FactoryGirl.create(:member)
    walt_whitman = FactoryGirl.create(:member, first_name: "Walt", last_name: "Whitman")

    visit '/members'

    expect(page).to have_content("All Book Club Members")
    expect(page).to have_content(emily_dickinson.first_name)
    expect(page).to have_content(emily_dickinson.email)
    expect(page).to have_content(walt_whitman.first_name)
    expect(page).to have_content(walt_whitman.email)

  end
end

