require "rails_helper"

RSpec.describe UserMailer, type: :mailer do

  describe "Registration Email" do
    include EmailSpec::Helpers
    include EmailSpec::Matchers
    include Rails.application.routes.url_helpers

    before(:each) do
      @user = FactoryGirl.create(:user, email: 'auser@gmail.com', first_name: "Joe", phone: "6541537596")
      @email = UserMailer.registration_confirmation(@user).deliver_now
    end

    it "should deliver to correct email" do
      expect(@email).to deliver_to('auser@gmail.com')
    end

    it "should have the correct subject" do
      expect(@email).to have_subject(/Bernie BNB - Registration Confirmation/)
    end

    it "should mention the user" do
      expect(@email).to have_body_text(@user.first_name)
    end

    it "should contain the correct body text" do
      expect(@email).to have_body_text(/Thanks for registering with Bernie BNB!/)
      expect(@email).to have_body_text(/Click the URL below to confirm your registration:/)
    end

    it "should contain a confirmation link" do
      expect(@email).to have_body_text(/#{@user.confirm_token}/)
    end
  end
end
