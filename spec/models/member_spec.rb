require 'spec_helper'

RSpec.describe Member do
  let(:book_club_member) { FactoryGirl.create(:member) }
  describe "#first_name" do
    it "should have a first name" do
      expect(book_club_member.first_name).to eq("Emily")
    end
  end
end
