require 'rails_helper'

describe 'A user can create friendships with ' do
  before(:each) do
    @josh = create(:user) #User in system with GH token
    @dione = create(:user) #GH follower of Josh in system
    @mike = create(:user)  #GH follower of Josh not in system

    stubbed_followers = []
    stubbed_followers << GithubData.new("Dione", "https://github.com")
    stubbed_followers << GithubData.new("Mike", "https://github.com")
    allow_any_instance_of(User).to receive(:token).and_return("ABC123")
    allow_any_instance_of(GithubResults).to receive(:display_github_data).and_call_original
    allow_any_instance_of(GithubResults).to receive(:display_github_data).with('followers').and_return(stubbed_followers)
    allow_any_instance_of(GithubResults).to receive(:display_github_data).with('following').and_return(stubbed_followers)
  end

  it 'followers' do
    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: @josh.email
    fill_in 'session[password]', with: @josh.password
    click_on 'Log In'
    visit '/dashboard'

    expect(@josh.friends).to eq([])

    within ".followers" do
      within "#dione" do
        expect(page).to have_link("Add as Friend")
        click_link("Add as Friend")
        expect(current_path).to eq('/dashboard')
      end
      within "#mike" do
        expect(page).to_not have_link("Add as Friend")
      end
    end

    within "#dione" do
      click_link("Add as Friend")
    end
    expect(current_path).to eq('/dashboard')
    expect(@josh.friends).to eq([@dione])
  end
end
