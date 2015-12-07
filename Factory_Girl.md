#Factory Girl Clinic

FactoryGirl is a gem that makes testing easier. It allows you to create "factories" for the objects your app is concerned with, thereby allowing you to more quickly set up tests for a feature or method. Once FactoryGirl is set up, instead of needing to type this:

```
let(:leader) { Member.new("Emily", "Dickinson", "nobody@nobodytoo.org", "I don't see what's so great about leaving the house.", "Aurora Leigh", true) }
```

I can use something more simple, like this:

```
let(:leader) { FactoryGirl.create(:club_leader) }
```
##Set Up in Sinatra

- [Elise's Starter Code](https://github.com/EliseFitz15/factory_girl_sinatra_setup)

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
- Run `bundle install` to install it!
- Next, make a file at `spec/support/factories.rb`. This is where you'll be creating your factories.
- Now open the spec_helper.rb file and add these lines to the top:

```ruby
require 'factory_girl'
require_relative 'support/factories'
```

- To create your database, open `config/database.yml` and update the file with names appropriate for your app. Then run `rake db:create`.

- Lastly, `require spec_helper` at the top of spec test files.

##Creating Factories

###Setting Up Your Factory File

Open up `spec/support/factories.rb`. Add the following code:

```ruby
FactoryGirl.define do

  # Your factories will go here!

end
```

You are now ready to write up your factories inside of this block!

###Writing a Simple Factory ([Documentation](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md#Defining_factories))

If we're using a Book Club example, we'll have `Book Club` objects and `Member` objects. Let's write a migration to set these tables up in our database:

```
rake db:create_migration NAME=create_book_clubs

class CreateBookClubs < ActiveRecord::Migration
  def change
    create_table :book_clubs do |t|
      t.string :name, null: false
      t.string :location
    end
  end
end

rake db:create_migration NAME=create_members

class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.text :bio
      t.string :favorite_book
      t.integer :book_club_id
      t.boolean :leader, null: false, default: false
    end
  end
end

```

Let's start with our `Member object`. Here's what creating a factory for that object would look like:

```ruby
factory :member do
  first_name "Emily"
  last_name "Dickinson"
  email "nobody@nobodytoo.org"
  bio "I don't see what's so great about leaving the house."
  favorite_book "Aurora Leigh"
end
```

It's that simple! Now every time I call `FactoryGirl.create(:member)`, I'll have a standardized book club member (in this case, Emily Dickinson).

###Using a Factory ([Documentation](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md#Using_factories))

Let's look at an example of how I would use this.

```
feature 'book club member directory' do
  scenario "view list of all book club members" do
    emily_dickinson = FactoryGirl.create(:member)
    visit '/members'

    expect(page).to have_content("All Book Club Members")
    expect(page).to have_content emily_dickinson.name
    expect(page).to have_content emily_dickinson.email
  end
end
```

####Using Factories with Custom info

This is all well and good, but our book clubs have leaders, too. The default member factory we created is not one, and we probably want to have a different test to make sure any given book club's leader(s) are displayed appropriately on the page. Let's try that out:

```
walt_whitman = FactoryGirl.create(:member, first_name: "Walt", last_name: "Whitman", bio: "Yawp", leader: true)
```

You can override any of the attributes that your factory sets by passing in an argument to modify that attribute. In this example, we're changing the first name, last name, bio, and leader status of the factory to suit our needs. This lets us still avoid duplicating some of our work in mocking up the data needed to test things that book club members can do, but with custom values when needed.

###Different Kinds of Objects (aka [Inheritance](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md#Inheritance))

Now, passing override values to our `member` factory might get old after a while if we need to write 15 feature tests where a book club leader is required. Let's go ahead and make a permanent factory for this kind of object. We can do this by inheriting most of the properties we want from the parent `member` object:

```ruby
factory :member do
    first_name "Emily"
    last_name "Dickinson"
    email "nobody@nobodytoo.org"
    bio "I don't see what's so great about leaving the house."
    favorite_book "Aurora Leigh"

    factory :club_leader do
      leader true
    end
  end
```

If we call `FactoryGirl.create(:club_leader)`, all of the default traits we set up in the normal `member` factory will still be there, *except* the one we explicitly overrode in the `book_club_leader` factory. Nesting things this way makes creating new factories for explicit uses very simple.


###Objects with Associations ([Documentation](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md#Associations))

Let's say we now have an `Book Club` class as well as Member, and there's a one-to-many relationship between them: an Book Club has many Members, and a Member belongs to a Book Club.

- New migration for active record book club object `rake db:create_migration NAME=create_book_club`
- Create table with name and location
- Create class in the 'app/model' directory
- `rake db:migrate` to create the table in the db
- Add associations: `Member` belongs to `Book Club`, `Book Club` has many members
- Create migration to add column for belongs_to `Book Club`

Usually when we create a member object, we'll know we want a book club object also. So we can add a factory for this purpose to our `factories.rb` file:

```ruby
factory :book_club do
  name "(Actually) Dead Poets Society"
  location "Amherst, MA"
end
```

Once that factory is set up, we can go back to our `member` factory and just add the word `book_club` on its own line in the factory definition. FactoryGirl will look for a factory of that name and create the associated object for us:

```ruby
factory :member do
  first_name "Emily"
  last_name "Dickinson"
  email "nobody@nobodytoo.org"
  bio "I don't see what's so great about leaving the house."
  favorite_book "Aurora Leigh"
  book_club
end
```

Now every time we create a new book club member, there will be a book club to go with it!

Or, let's say we want to add a book club member to a specific, pre-existing club. We can just overwrite this default information like before:

```
book_club = FactoryGirl.create(:book_club, name: "Cranky Poet's Society")
emily_dickinson = FactoryGirl.create(:member, book_club: book_club)
```

Now Emily will belong to the book club we already created.

##Fancier Factories

###Objects with Uniqueness Constraints (aka [Sequencing](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md#Sequences))

As of right now, all book club members I create will have the same email (unless otherwise specified). What if I have a uniqueness constraint on book club members' emails, so I can't have duplicate emails in my database?

Let's write the migration that would modify this:

```
rake db:create_migration NAME=make_member_emails_unique

class MakeMemberEmailsUnique < ActiveRecord::Migration
  def change
    change_column :members, :email, :string, unique: true, null: false
  end
end

```

Let's also add a uniqueness constraint on the class/model itself:

```
class Member < ActiveRecord::Base
  belongs_to :book_club

  validates :email, uniqueness: true
end

```

Now we can return to our testing and set up a sequence, meaning that each time you use the factory to create a new book club member, the `n` in the block you wrote will increment by 1. So first we'll have "nobody1@nobodytoo.org", then "nobody2@nobodytoo.org", etc!


```ruby
# factories.rb
factory :member do
  # ..other attributes
  sequence(:email) { |n| "nobody#{n}@nobodytoo.org" }
end
```

Let's add a feature test and we can display our book club members and their emails:

```ruby
feature 'book club members directory' do
  scenario "view list of book club members" do
    emily = FactoryGirl.create(:member)
    visit '/members'

    expect(page).to have_content("Book Club Members Directory")
    expect(page).to have_content (emily.first_name)
    expect(page).to have_content (emily.email)
  end
end
```

###[Lists](https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#building-or-creating-multiple-records) of Objects

Now, let's say we want to write a relatively realistic tests, wherein our book club has 15 members, 3 of whom are club leaders. Factory Girl can help us do this pretty easily with `create_list`. Here's how it might look:

```
feature "view a book club's members" do
  scenario 'see all members of a particular book club' do
    book_club = FactoryGirl.create(:book_club)
    members = FactoryGirl.create_list(:member, 12, book_club: book_club)
    leaders = FactoryGirl.create_list(:club_leader, 3, book_club: book_club)

    visit "/book_clubs/#{book_club.id}"

    members.each do |member|
      expect(page).to have_content(member.first_name)
    end

    leaders.each do |leader|
      expect(page).to have_content("#{leader.first_name} (Leader)")
    end
  end
end
```

Listed below are some additional resources on using Factory Girl. *Note: These resources will presume you use Rails with ActiveRecord and FactoryGirl. It works the same way as in Sinatra with ActiveRecord.*

- [Rails Gist](https://gist.github.com/cmkoller/1dcc8815669d02b5a793)
- [Documentation](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md)
- [Horizon Reading](https://horizon.launchacademy.com/lessons/factory-girl)
- [Horizon Reading on FG Associations](https://horizon.launchacademy.com/lessons/factory-girl-associations)
