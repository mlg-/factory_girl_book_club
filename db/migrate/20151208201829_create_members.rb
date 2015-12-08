class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.text :bio
      t.string :favorite_book
      t.belongs_to :book_club
      t.boolean :leader, null: false, default: false
    end
  end
end
