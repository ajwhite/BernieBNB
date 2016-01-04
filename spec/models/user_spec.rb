require 'rails_helper'
require 'spec_helper'

RSpec.describe User, type: :model do
  it "has a valid factory - 10 digits in phone number" do
    expect(FactoryGirl.create(:user, phone: "2345678901")).to be_valid
  end

  it "is not valid without a Uid" do
    expect { FactoryGirl.create(:user, uid: nil, phone: "2345678901") }
      .to raise_error ActiveRecord::RecordInvalid
  end

  it "allows no email, but if present, can't be blank" do
    expect(FactoryGirl.create(:user, phone: "2345678901", email: nil)).to be_valid
    expect { FactoryGirl.create(:user, email: "", phone: "2345678901") }
      .to raise_error ActiveRecord::RecordInvalid
  end

  it "allows no first name, but if present, can't be blank" do
    expect(FactoryGirl.create(:user, first_name: nil, phone: "2345678901")).to be_valid
    expect { FactoryGirl.create(:user, first_name: "", phone: "2345678901") }
      .to raise_error ActiveRecord::RecordInvalid
  end

  it "automatically generates a session token on creation" do
    user = FactoryGirl.create(:user, phone: "2345678901")
    expect(user.session_token).to_not be_nil
  end

  it "allows no phone number, but if present, can't be blank - empty phone number" do
    expect(User.create(uid: SecureRandom.urlsafe_base64(17),
      email: "test@fakemail.com", phone: "2345678901")).to be_valid
    expect { FactoryGirl.create(:user, phone: "") }
      .to raise_error ActionView::Helpers::NumberHelper::InvalidNumberError
  end

  it "bad phone number -- 1 in front - 10 digits" do
    expect { FactoryGirl.create(:user, phone: "1234567890") }
      .to raise_error ActiveRecord::RecordInvalid
  end

  it "bad phone number -- 11 digits (too long)" do
    expect { FactoryGirl.create(:user, phone: "23456789012") }
      .to raise_error ActiveRecord::RecordInvalid
  end

  it "has a valid factory - valid phone - 11 chars" do
    expect(FactoryGirl.create(:user, phone: "404-5551212")).to be_valid
  end

  it "has a valid factory - with periods - 12 chars" do
    expect(FactoryGirl.create(:user, phone: "404.555-1212")).to be_valid
  end

  it "has a valid factory - with paraentheses - 13 chars" do
    expect(FactoryGirl.create(:user, phone: "(404)555-1212")).to be_valid
  end

  it "has a valid factory - with hyphens/dashes and leadinig '1' - 14 chars" do
    expect(FactoryGirl.create(:user, phone: "1-404-555-1212")).to be_valid
  end

  it "has a valid factory - with paraentheses and blank - 14 chars" do
    expect(FactoryGirl.create(:user, phone: "(404) 555-1212")).to be_valid
  end

  it "has a valid factory - with periods and leadning '1' - 14 chars" do
    expect(FactoryGirl.create(:user, phone: "1.404.555-1212")).to be_valid
  end

  it "has a valid factory - 15 digits in phone number" do
    expect(FactoryGirl.create(:user, phone: "1-(404)555.1212")).to be_valid
  end

  it "has a valid factory - 16 digits in phone number" do
    expect(FactoryGirl.create(:user, phone: "1-(404) 555.1212")).to be_valid
  end
end
