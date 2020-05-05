require 'rails_helper'

describe 'A registered user' do
  it 'can see a list of github repos' do
    user = create(:user)
    user.update(token: "9ee6197bb82833d6abddb45c3b94d711b128bf76")

    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    click_on 'Log In'
    visit '/dashboard'

    expect(page).to have_css(".repos")
  end

  it 'cant see a list of github repos if it doesnt have a token' do
    user = create(:user)

    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    click_on 'Log In'
    visit '/dashboard'

    expect(page).to_not have_css(".repos")
  end
end
