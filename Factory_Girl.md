#Factory Girl Clinic

FactoryGirl is a gem that helps you with testing. It basically allows you to create "factories" that crank out objects to your database for you to test. Once FactoryGirl is set up, instead of needing to type this:

```
let(:pokemon) { Pokemon.new("Onyx", "Rock Smash", "Earth", 50, 2, pokemaster: pokemaster) }
```

I can type something like this:

```
let(:pokemon) { FactoryGirl.create(:pokemon) }
```
##Set Up in Sinatra

- [Starter-Code](https://github.com/EliseFitz15/factory_girl_sinatra_setup)


```
 git clone https://github.com/EliseFitz15/factory_girl_sinatra_setup <YOUR_APP_NAME>
 cd <YOUR_APP_NAME>
 bundle install
 rm -rf .git && git init && git add -A && git commit -m 'Initial commit'
```

- First, add Factory Girl to your Gemfile:

```ruby
group :development, :test do
  # ... other gems ...
  gem 'factory_girl'
end
```
- Then `bundle install` to install it!
- Next make a file at `spec/support/factories.rb`. This is where you'll be creating your factories!
- Now open the spec_helper.rb file and add these lines to the top

```ruby
require 'factory_girl'
require_relative 'support/factories'
```

- Create our database. Go to  'config/database.yml' and update the file with the database names. Then `rake db:create`

- Lastly, we will just need `require spec_helper` at the top of spec test files.

##Creating Factories

###Setting up the space

Open up `spec/support/factories.rb`. Add the following code:

```ruby
FactoryGirl.define do

  # Your factories will go here!

end
```

You've now set up the space to write all your factories.

###Write Tests
- In your 'spec/model' directory create spec files for each model object
- New migration for active record pokemon object `rake db:create_migration NAME=create_pokemons`
- Create table with name, ability, poketype(type can't be a column), strength, age
- `rake db:migrate` to create the table in the db

In the 'spec/models/pokemon_spec.rb' we can start with the following tests:
```ruby

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
  it "should be evolved" do
    expect(pokemon.name).to eq("Ivysaur")
    expect(pokemon.age).to eq(3)
  end
end

```

Let's use FactoryGirl to create these objects

###Writing a Simple Factory ([Documentation](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md#Defining_factories))

Let's start with our Pokemon object. A Pokemon object has the following attributes. In our `factories.rb` file, this is what we would write:

```ruby
factory :pokemon do
  name "Bulbasaur"
  ability "Overgrow"
  poketype "Grass"
  strength 25
  age 2
end
```

It's that simple! Now we've set default values for our Test Pokemon's name, ability, strength, poketype and age. Every time we use FactoryGirl to create a pokemon it'll be this Bulbasaur.

###Using a Factory ([Documentation](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md#Using_factories))

Now that this factory is set up, ANY time we want to create a Pokemon object in one of our tests files, we can say:

```
pokemon = FactoryGirl.create(:pokemon)
```

This will return a new Pokemon object with the name "Bulbasaur" and the age 2, just as if we had called:

```
bulbasaur = Pokemon.create(name: "Bulbasaur", ability: "Overgrow", poketype: "Grass", strength: 25, age: 2)
```

####Using Factories with Custom info

What if I love using my factory, but for this one test I want to see if the pokemon evolved so I need an older pokemon to test? I can still use the factory I set up earlier, but override one of the default values with my own info:

```
Ivysaur = FactoryGirl.create(:pokemon, name: "Ivysaur", age: 3)
```

Now we've created a pokemon with all the default info we specified in our factory, *except* for name and age which we've overridden. This can be very useful if you have a lot of info in your factory, and just want to change a small piece of it!

###Different Kinds of Objects (aka [Inheritance](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md#Inheritance))

Let's say we're making a lot of tests that use evolved pokemon, as well as a lot of tests that use default young ones. Instead of needing to manually override "age" and name every time, we should create a special factory for evolved pokemon!

We can make a new factory called `:evolved_pokemon` inside the `:pokemon` factory like so:

```ruby
factory :pokemon do
  name "Bulbasaur"
  ability "Overgrow"
  poketype "Grass"
  strength 25
  age 2

  factory :evolved_pokemon do
    name "Ivysaur"
    age 3
  end
end
```

If we call `FactoryGirl.create(:evolved_pokemon)`, all of the default traits we set up in the normal `pokemon` factory will still be there, *except* the ones we explicitly override in the `evolved_pokemon` factory.


###Objects with Associations ([Documentation](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md#Associations))

Let's say we now have an Pokemaster model class as well as Pokemon, and there's a one-to-many relationship between them: an Pokemaster has many Pokemon, and a Pokemon belongs to Pokemaster.

- Let's add a new test in the 'spec/model' directory
- New migration for active record pokemon object `rake db:create_migration NAME=create_pokemasters`
- Create table with name, age, email
- Create class in the 'app/model' directory
- `rake db:migrate` to create the table in the db
- Add associations - What do we need?
- Create migration to add column for belongs_to pokemaster
- create our test in 'spec/models/pokemasters_spec.rb'

```ruby
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

```

We don't want to have any wild pokemon being created without having pokemasters, so let's add a factory for Pokemasters to our `factories.rb` file:

```ruby
factory :pokemaster do
  name "Ash"
  age 14
  email "pokemaster@gmail.com"
end
```

Once that factory is set up we can go back to our pokemon factory and just add the word `pokemaster` as a line. If we don't set value, FactoryGirl will go and look for a factory of that name and create the associated object for us!

```ruby
factory :pokemon do
  name "Bulbasaur"
  ability "Overgrow"
  poketype "Grass"
  strength 25
  age 2
  pokemaster
end
```

Now every time we create a new pokemon, it'll create a new pokemaster to go with it. Let's check it out by adding the following tests to our pokemon_spec.rb:

```ruby
describe '#pokemaster' do
  it "should have pokemaster" do
    expect(pokemon.pokemaster.name).to eq("Ash")
  end

  it "should have Brock as a pokemaster" do
    expect(brocks_pokemon.pokemaster.name).to eq("Brock")
  end
end
```

Or, let's say we want to create a pokemon with a specific, pre-existing pokemaster. We can just overwrite this default information like before:

```
brock = FactoryGirl.create(:pokemaster, name: "Brock")
brocks_pokemon = FactoryGirl.create(:pokemon, pokemaster: brock)
brocks_pokemon.pokemaster
=> #<Pokemaster:0x007f8e56d73a70 id: 1, name: "Brock", age: 14, email: "pokemaster@gmail.com">
```

##Fancier Factories

###Objects with Uniqueness Constraints (aka [Sequencing](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md#Sequences))

As of right now, all pokemasters I create will have the same email (unless otherwise specified). What if I have a uniqueness constraint on pokemasters' emails, so I can't have duplicate emails in my database?

We can set up a sequence, meaning that each time you use the factory to create a new pokemaster, the `n` in the block you wrote will increment by 1. So first we'll have "pokemaster1@gmail.com", then "pokemaster2@gmail.com", etc!


```ruby
# factories.rb
factory :pokemaster do
  # ..other attributes
  sequence(:email) { |n| "pokemaster#{n}@gmail.com" }
end
```
Let's add a feature test and we can display our pokemasters and their emails:

```ruby
feature 'pokemasters directory' do
  scenario "view list of pokemasters" do
    visit '/pokemasters'

    expect(page).to have_content("Pokemasters Directory")
    expect(page).to have_content ("Ash")
    expect(page).to have_content ("pokemaster@gmail.com")
  end
end
```

These are some examples while using ActiveRecord and a TDD approach to using FactoryGirl in a Sinatra app. These leverage Rspec and model/unit testing. Factory girl is also great to use with acceptance testing. Here are some more resources for using FactoryGirl and getting it set up in rails.

- [Rails Gist](https://gist.github.com/cmkoller/1dcc8815669d02b5a793)
- [Documentation](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md)
- [Horizon Reading](https://horizon.launchacademy.com/lessons/factory-girl)
- [Horizon Reading on FG Associations](https://horizon.launchacademy.com/lessons/factory-girl-associations)
