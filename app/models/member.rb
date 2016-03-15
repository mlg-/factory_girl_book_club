class Member < ActiveRecord::Base
  belongs_to :book_club

  validates :email, uniqueness: true
end
