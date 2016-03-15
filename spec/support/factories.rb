FactoryGirl.define do
  factory :member do
    first_name "Emily"
    last_name "Dickinson"
    sequence(:email) { |n| "nobody#{n}@nobodytoo.org" }
    bio "I don't see what's so great about leaving the house."
    favorite_book "Aurora Leigh"
    book_club

    factory :club_leader do
      leader true
    end
  end

  factory :book_club do
    name "(Actually) Dead Poets' Society"
    location "Amherst, MA"
  end
end
