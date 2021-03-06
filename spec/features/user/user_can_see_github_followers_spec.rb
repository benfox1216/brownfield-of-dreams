require 'rails_helper'

describe 'A registered user' do
  it 'can see the github followers section', :vcr do
    user = create(:user)
    user.update(token: ENV["GITHUB_API_KEY"])

    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    click_on 'Log In'
    visit '/dashboard'

    expect(page).to have_css(".followers")
  end

  it 'cant see the github followers section if it doesnt have a token' do
    user = create(:user)

    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    click_on 'Log In'
    visit '/dashboard'

    expect(page).to_not have_css(".followers")
  end

  it 'can see a list of followers in the section', :vcr do
    user = create(:user)
    stubbed_followers = []
    stubbed_followers << GithubData.new("reid-andrew", "https://github.com/reid-andrew")
    stubbed_followers << GithubData.new("benfox1216", "https://github.com/benfox1216")
    allow_any_instance_of(User).to receive(:token).and_return("ABC123")
    allow_any_instance_of(GithubResults).to receive(:display_github_data).and_call_original
    allow_any_instance_of(GithubResults).to receive(:display_github_data).with('followers').and_return(stubbed_followers)

    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    click_on 'Log In'
    visit '/dashboard'

    within ".followers" do
      expect(page).to have_link("reid-andrew")
      expect(page).to have_link("benfox1216")
    end
  end
end
