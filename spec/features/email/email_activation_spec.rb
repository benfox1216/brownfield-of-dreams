require 'rails_helper'

describe 'As an unregistered user when I try to register I ' do

  it 'should see a flash message about account activation' do
    visit '/'
    click_link 'Register'

    expect(current_path).to eq('/register')

    fill_in 'user[email]', with: 'registration_test@example.com'
    fill_in 'user[first_name]', with: 'Joe'
    fill_in 'user[last_name]', with: 'Hill'
    fill_in 'user[password]', with: '1234'
    fill_in 'user[password_confirmation]', with: '1234'

    click_button 'Create Account'

    expect(current_path).to eq('/dashboard')
    expect(page).to have_content('Logged in as Joe Hill.')
    expect(page).to have_content('This account has not yet been activated. Please check your email.')
  end

  it 'should be directed to activation page when clicking link in email' do
    user = create(:user)

    visit "/confirmed/#{user.id}"

    expect(page).to have_content('Thank you! Your account is now activated.')

    click_button 'Go to Dashboard'

    expect(current_path).to eq('/dashboard')
    expect(page).to have_content('Status: Active')
  end
end
