require 'rails_helper'

describe 'A registered user' do
  it 'can see a list of github repos' do
    user = create(:user)

    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    click_on 'Log In'
    visit '/dashboard'

    within "#repos" do
      expect(page).to have_content(user.repo[0])
    end
  end
end
