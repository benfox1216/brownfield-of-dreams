require 'rails_helper'

describe 'A user can create friendships with ' do
  before(:each) do
    @josh = create(:user) #User in system with GH token
    @dione = create(:user) #GH follower of Josh in system
    @dione.update(github_username: "dione")
    @dione.reload
    @mike = create(:user)  #GH follower of Josh not in system
    @mike.update(github_username: nil)
    @mike.reload

    stubbed_followers = []
    stubbed_followers << GithubData.new("dione", "https://github.com")
    stubbed_followers << GithubData.new("mike", "https://github.com")
    allow_any_instance_of(User).to receive(:token).and_return("ABC123")
    allow_any_instance_of(GithubResults).to receive(:display_github_data).and_call_original
    repo_response = File.read('spec/fixtures/github_fixtures/repos.json')
    stub_request(:any, "https://api.github.com/user/repos").to_return(body: repo_response)
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
        expect(page).to have_button("Add as Friend")
      end
      within "#mike" do
        expect(page).to_not have_button("Add as Friend")
      end
    end

    within ".followers" do
      within "#dione" do
        click_button("Add as Friend")
      end
    end
    expect(current_path).to eq('/dashboard')
    expect(@josh.user_friends).to eq([@dione])
  end

  it 'following' do
    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: @josh.email
    fill_in 'session[password]', with: @josh.password
    click_on 'Log In'
    visit '/dashboard'

    expect(@josh.friends).to eq([])
    within ".following" do
      within "#dione" do
        expect(page).to have_button("Add as Friend")
      end
      within "#mike" do
        expect(page).to_not have_button("Add as Friend")
      end
    end

    within ".following" do
      within "#dione" do
        click_button("Add as Friend")
      end
    end
    expect(current_path).to eq('/dashboard')
    expect(@josh.user_friends).to eq([@dione])
  end

  it 'followers and see them on the dashboard' do
    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: @josh.email
    fill_in 'session[password]', with: @josh.password
    click_on 'Log In'
    visit '/dashboard'
    within ".followers" do
      within "#dione" do
        click_button("Add as Friend")
      end
    end

    within ".friends" do
      expect(page).to have_content(@dione.first_name)
      expect(page).to have_content(@dione.last_name)
      expect(page).to_not have_content(@mike.first_name)
      expect(page).to_not have_content(@mike.last_name)
    end
  end

  it 'followers and then no longer see friendship button' do
    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: @josh.email
    fill_in 'session[password]', with: @josh.password
    click_on 'Log In'
    visit '/dashboard'

    within ".followers" do
      within "#dione" do
        expect(page).to have_button("Add as Friend")
      end
    end

    within ".following" do
      within "#dione" do
        expect(page).to have_button("Add as Friend")
      end
    end

    within ".followers" do
      within "#dione" do
        click_button("Add as Friend")
      end
    end

    within ".followers" do
      within "#dione" do
        expect(page).to_not have_button("Add as Friend")
      end
    end

    within ".following" do
      within "#dione" do
        expect(page).to_not have_button("Add as Friend")
      end
    end
  end

  it 'followers and gracefully fail if something goes wrong' do
    allow_any_instance_of(FriendsController).to receive(:friend_params)
                                            .and_return({user_id: 99, user_friend_id: 1234})
    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: @josh.email
    fill_in 'session[password]', with: @josh.password
    click_on 'Log In'
    visit '/dashboard'
    within ".followers" do
      within "#dione" do
        click_button("Add as Friend")
      end
    end
    expect(current_path).to eq('/dashboard')
    expect(page).to have_content('This friendship cannot be created.')
  end
end
