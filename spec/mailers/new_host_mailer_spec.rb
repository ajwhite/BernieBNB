require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "New Host Email" do
    include EmailSpec::Helpers
    include EmailSpec::Matchers
    include Rails.application.routes.url_helpers
  end

  before(:each) do
    Geocoder.configure(:lookup => :test)

    Geocoder::Lookup::Test.add_stub(
      "11211", [{'latitude' => 40.7093358, 'longitude' => -73.9565551}]
    )

    @host = FactoryGirl.create(:user, email: 'joe@gmail.com', first_name: "Joe", phone: "6541537596")

    @visitor = FactoryGirl.create(:user, email: "bart@yahoo.com", first_name: "Bart", phone: "666-874-9632")

    start_date = '02-03-2956'
    end_date = '02-06-2956'

    @visit = Visit.create!(start_date: start_date, end_date: end_date, zipcode: '11211', num_travelers: 1, user_id: @visitor.id)

    @hosting = Hosting.create!(zipcode: @visit.zipcode, max_guests: @visit.num_travelers, host_id: @host.id)

    @email = UserMailer.new_host_email(@visit, @hosting).deliver_now
  end

  it "should deliver to the correct email address" do
    expect(@email).to deliver_to('bart@yahoo.com')
  end

  it "should have the correct subject" do
    expect(@email).to have_subject(/Bernie BNB - New host near #{@hosting.zipcode}/)
  end

  it 'should mention the correct visitor name' do
    expect(@email).to have_body_text(/#{@visitor.first_name}/)
  end

  it 'should mention the correct host name' do
    expect(@email).to have_body_text(/#{@host.first_name}/)
  end

  it 'should reference the correct distance' do
    expect(@email).to have_body_text(/#{@hosting.distance_from(@visit).round(1)}/)
  end

  it 'should mention the correct zip code' do
    expect(@email).to have_body_text(/#{@visit.zipcode}/)
  end

  it 'should contain a results link' do
    expect(@email).to have_body_text(/Bernie BNB - Results for #{@visit.zipcode}/)
  end


end
