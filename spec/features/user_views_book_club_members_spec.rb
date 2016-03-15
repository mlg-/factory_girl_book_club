require "spec_helper"

feature "book club member directory" do
  scenario "view list of all book club members" do
    emily = FactoryGirl.create(:member)
    walt = FactoryGirl.create(:member, first_name: "Walt", last_name: "Whitman", book_club: emily.book_club)

    visit '/members'

    expect(page).to have_content("All Book Club Members")
    expect(page).to have_content("#{walt.first_name} #{walt.last_name}")
    expect(page).to have_content("#{emily.first_name} #{emily.last_name}")
  end
end
