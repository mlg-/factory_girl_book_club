class MakeMemberEmailsUnique < ActiveRecord::Migration
  def up
    change_column :members, :email, :string, unique: true, null: false
  end

  def down
    change_column :members, :email, :string, null: false
  end
end
