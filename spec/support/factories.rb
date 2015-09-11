FactoryGirl.define do

  factory :pokemon do
    name "Bulbasaur"
    ability "Overgrow"
    poketype "Grass"
    strength 25
    age 2
    pokemaster

    factory :evolved_pokemon do
      name "Ivysaur"
      age 3
    end
  end

  factory :pokemaster do
    name "Ash"
    age 14
    sequence(:email) { |n| "pokemaster#{n}@gmail.com" }
  end
end
