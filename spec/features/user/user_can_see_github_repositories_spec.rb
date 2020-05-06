require 'rails_helper'

describe 'A registered user' do
  it 'can see the github repos section' do
    user = create(:user)
    user.update(token: ENV["GITHUB_API_KEY"])

    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    click_on 'Log In'
    visit '/dashboard'

    expect(page).to have_css(".repos")
  end

  it 'cant see the github repos section if it doesnt have a token' do
    user = create(:user)

    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    click_on 'Log In'
    visit '/dashboard'

    expect(page).to_not have_css(".repos")
  end

  it 'can see a list of repos in the section' do
    user = create(:user)
    stubbed_repos = []
    stubbed_repos << Repo.new("Google", "www.google.com")
    stubbed_repos << Repo.new("Yahoo", "www.yahoo.com")

    allow_any_instance_of(ApplicationController).to receive(:display_repos).and_return(stubbed_repos)

    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    click_on 'Log In'
    visit '/dashboard'

    within ".repos" do
      expect(page).to have_link("GOOGLE")
      expect(page).to have_link("YAHOO")
    end
  end
end
