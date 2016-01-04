module FeatureTestHelper
  def authenticate_with_facebook
    visit root_path
    click_link 'Facebook'
  end

  def fill_in_user_details
    fill_in "What's your first name?", with: 'Jane'
    fill_in "What's your phone number?", with: '5555555555'

    click_button "Send Email Confirmation"
  end

  def register_new_user
    authenticate_with_facebook
    fill_in_user_details
    visit confirm_email_user_url(User.last.confirm_token)
  end

  def create_visit(start_date, end_date, zipcode='11211', num_travelers=2)
    click_link "Find A Host"
    fill_in "Where are you going?", with: zipcode
    fill_in "Arriving when?", with: start_date
    fill_in "Departing when?", with: end_date
    find('#visit_num_travelers').select(num_travelers)
    click_button "Contact Hosts"
  end

  def create_host(zipcode='11211', max_guests=2)
    click_link "I Can Host"
    fill_in "Where are you located?", with: zipcode
    find('#hosting_max_guests').select(max_guests)
    click_button("Save")
  end

  def delete_host
    click_link "11211 (2 guests)"
    click_link "Delete"
  end
end



RSpec.configure do |config|
  config.include FeatureTestHelper, :type => :feature
end
