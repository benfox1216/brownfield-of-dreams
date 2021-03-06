require 'rails_helper'

describe 'A registered user' do
  it 'can see the github following section', :vcr do
    user = create(:user)
    user.update(token: ENV["GITHUB_API_KEY"])

    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    click_on 'Log In'
    visit '/dashboard'

    expect(page).to have_css(".following")
  end

  it 'cant see the github following section if it doesnt have a token' do
    user = create(:user)

    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    click_on 'Log In'
    visit '/dashboard'

    expect(page).to_not have_css(".following")
  end

  it 'can see a list of following in the section', :vcr do
    user = create(:user)
    stubbed_following = []
    stubbed_following << GithubData.new("reid-andrew", "https://github.com/reid-andrew")
    stubbed_following << GithubData.new("benfox1216", "https://github.com/benfox1216")

    allow_any_instance_of(User).to receive(:token).and_return("ABC123")
    allow_any_instance_of(GithubResults).to receive(:display_github_data).and_call_original
    allow_any_instance_of(GithubResults).to receive(:display_github_data).with('following').and_return(stubbed_following)

    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    click_on 'Log In'
    visit '/dashboard'

    within ".following" do
      expect(page).to have_link("reid-andrew")
      expect(page).to have_link("benfox1216")
    end
  end
end
