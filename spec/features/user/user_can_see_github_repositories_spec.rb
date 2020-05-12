require 'rails_helper'

describe 'A registered user' do
  it 'can see the github repos section', :vcr do
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

  it 'can see a list of 5 repos in the section', :vcr do
    user = create(:user)
    user.update(token: "Not_a_real_token")
    stubbed_repos = [{"id"=>1, "name"=>"Google", "html_url"=>"www.google.com"},
                    {"id"=>2, "name"=>"Yahoo", "html_url"=>"www.yahoo.com"},
                    {"id"=>3, "name"=>"Bing", "html_url"=>"www.yahoo.com"},
                    {"id"=>4, "name"=>"Alta Vista", "html_url"=>"www.altavista.com"},
                    {"id"=>5, "name"=>"Search", "html_url"=>"www.search.com"},
                    {"id"=>6, "name"=>"Imgur", "html_url"=>"www.imgur.com"},
                    {"id"=>7, "name"=>"Ask Jeeves", "html_url"=>"www.askjeeves.com"}]

    allow_any_instance_of(GithubResults).to receive(:call_github_service).and_call_original
    allow_any_instance_of(GithubResults).to receive(:call_github_service).with('repos', user).and_return(stubbed_repos)

    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    click_on 'Log In'
    visit '/dashboard'

    within ".repos" do
      expect(page).to have_link("GOOGLE")
      expect(page).to have_link("YAHOO")
      expect(page).to have_link("BING")
      expect(page).to have_link("ALTA VISTA")
      expect(page).to have_link("SEARCH")
      expect(page).to_not have_link("IMGUR")
      expect(page).to_not have_link("ASK JEEVES")
    end
  end
end
