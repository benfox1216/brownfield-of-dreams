require 'rails_helper'

describe 'As a registered user when I ' do
  before (:each), :vcr do
    user = create(:user)
    user.update(token: ENV["GITHUB_API_KEY"])
    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    click_on 'Log In'
  end
  it 'click on Invite I see the Invites page', :vcr do
    visit '/dashboard'
    click_on 'Send an Invite'

    expect(current_path).to eq('/invite')
  end

  it 'invite a Github user with an email address it sends an email', :vcr do
    visit '/dashboard'
    click_on 'Send an Invite'
    fill_in 'github_handle', with: 'gibberish'
    click_on 'Send Invite'

    expect(current_path).to eq('/dashboard')
    expect(page).to have_content('Successfully sent invite!')
  end

  it 'invite a Github user with an email address it sends an email', :vcr do
    visit '/dashboard'
    click_on 'Send an Invite'
    fill_in 'github_handle', with: 'gibberish'
    click_on 'Send Invite'

    expect(current_path).to eq('/dashboard')
    expect(page).to have_content("The Github user you selected doesn't have an email address associated with their account.")
  end
end
