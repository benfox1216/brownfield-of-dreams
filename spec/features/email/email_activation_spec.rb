require 'rails_helper'

describe 'As an unregistered user when I try to register I ' do

  it 'Should see a flash message about account activation' do
    visit '/'
    click_link 'Register'

    expect(current_path).to eq('/register')

    fill_in 'user[email]', with: 'registration_test@example.com'
    fill_in 'user[first_name]', with: 'Joe'
    fill_in 'user[last_name]', with: 'Hill'
    fill_in 'user[password]', with: '1234'
    fill_in 'user[password_confirmation]', with: '1234'

    click_button 'Create Account'
    save_and_open_page
    expect(current_path).to eq('/dashboard')
    expect(page).to have_content('Logged in as Joe Hill.')
    expect(page).to have_content('This account has not yet been activated. Please check your email.')
  end
end
