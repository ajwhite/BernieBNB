require 'rails_helper'

RSpec.describe Contact, type: :model do
  before :each do
    FactoryGirl.create :contact, visitor_id: 1, hosting_id: 2
  end

  it "has a valid factory" do
    expect(FactoryGirl.build(:contact)).to be_valid
  end

  it "does not allow visitor to contact host more than once" do
    expect(FactoryGirl.build :contact, visitor_id: 1, hosting_id: 2)
      .to_not be_valid
  end

  it "allows a user to both host and visit other users" do
    expect(FactoryGirl.build :contact, visitor_id: 2, hosting_id: 1)
      .to be_valid
  end
end
