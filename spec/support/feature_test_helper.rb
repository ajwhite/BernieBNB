module FeatureTestHelper
  def authenticate_with_facebook
    visit root_path
    click_link 'Facebook'
  end

  def authenticate_with_google
    visit root_path
    click_link 'Google'
  end

  def fill_in_user_details
    fill_in "What's your first name?", with: 'Jane'
    fill_in "What's your phone number?", with: '5555555555'

    click_button "Confirm Email"
  end

  def register_new_facebook_user
    authenticate_with_facebook
    fill_in_user_details
    visit confirm_email_user_url(User.last.confirm_token)
  end

  def register_new_google_user
    authenticate_with_google
    fill_in_user_details
    visit confirm_email_user_url(User.last.confirm_token)
  end

  def create_visit(
      start_date=Date.current,
      end_date=Date.current + 1.days,
      zipcode='11211',
      num_travelers=10
    )

    click_link "Find A Host"
    fill_in "Where are you going?", with: zipcode
    find('#visit_start_date').set(start_date)
    find('#visit_end_date').set(end_date)
    find('#visit_num_travelers').select(num_travelers)
    click_button "Contact Hosts"
  end

  def create_host(zipcode='11211', max_guests=10)
    click_link "I Can Host"
    fill_in "Where are you located?", with: zipcode
    find('#hosting_max_guests').select(max_guests)
    click_button("Save")
  end

  def delete_host
    click_link "11211 (10 guests)"
    click_link "Delete"
  end
end



RSpec.configure do |config|
  config.include FeatureTestHelper, :type => :feature
end
