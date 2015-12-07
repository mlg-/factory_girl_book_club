class MakeMemberEmailsUnique < ActiveRecord::Migration
  def change
    change_column :members, :email, :string, unique: true, null: false
  end
end
