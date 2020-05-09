require 'rails_helper'

describe 'A registered user' do
  before(:each) do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = nil
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
  end

  it 'use OAuth to log in to GitHub' do
    user = create(:user)

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      "provider"=>"github",
      "uid"=>"53981830",
      "credentials"=>{"token"=>ENV["GITHUB_API_KEY"], "expires"=>false}})

    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    click_on 'Log In'
    visit '/dashboard'

    expect(page).to_not have_css(".followers")
    expect(page).to_not have_css(".following")
    expect(page).to_not have_css(".repos")

    click_on "Connect to Github"

    expect(page).to have_current_path('/dashboard')
    expect(page).to have_css(".followers")
    expect(page).to have_css(".following")
    expect(page).to have_css(".repos")
  end
end
