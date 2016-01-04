require 'spec_helper'
require 'rails_helper'
require_relative '../support/feature_test_helper'

RSpec.describe "User creates Host", type: :feature do
  before do
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
    register_new_user

    Geocoder.configure(:lookup => :test)

    Geocoder::Lookup::Test.add_stub(
      "11211", [{'latitude' => 40.7093358, 'longitude' => -73.9565551}]
    )

    Geocoder::Lookup::Test.add_stub(
      "11225", [{'latitude' => 40.6675, 'longitude' => -73.9856}]
    )

    Geocoder::Lookup::Test.add_stub(
      "63130", [{'latitude' => 38.6682669, 'longitude' => -90.3230806}]
    )

    Geocoder::Lookup::Test.add_stub(
      "1121", [{'latitude' => 38.6682669, 'longitude' => -90.3230806}]
    )


  end

  scenario "creating a new hosting" do
    create_host
    expect(page).to have_content("11211 (2 guests)")
  end

  scenario "creating a new hosting with blank fields" do
    click_link "I Can Host"
    click_button("Save")
    expect(page).to have_content "Zipcode can't be blank"
    expect(page).to have_content "Zipcode need to be 5 digits."
  end

  scenario 'creating a new hosting with the wrong zipcode' do
    click_link "I Can Host"
    fill_in "Where are you located?", with: '1121'
    click_button("Save")
    expect(page).to have_content "Zipcode need to be 5 digits."
  end

  scenario "deleting a hosting" do
    create_host
    expect(page).to have_content("11211 (2 guests)")
    delete_host
    expect(page).not_to have_content("11211 (2 guests)")
  end

  scenario "updating a hosting guest number" do
    create_host
    expect(page).to have_content("11211 (2 guests)")
    click_link '11211'
    find("#hosting_max_guests").select(3)
    click_button "Save"
    expect(page).to have_content("11211 (3 guests)")
  end

  scenario "updating a hosting zip code" do
    create_host
    expect(page).to have_content("11211 (2 guests)")
    click_link '11211'
    fill_in "Where are you located?", with: '63130'
    find("#hosting_max_guests").select(2)
    click_button "Save"
    expect(page).to have_content("63130 (2 guests)")
  end


end
