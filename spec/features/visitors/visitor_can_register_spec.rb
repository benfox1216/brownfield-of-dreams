require 'rails_helper'

describe 'vistor can create an account' do
  it ' visits the home page', :vcr do
    email = 'jimbob@aol.com'
    first_name = 'Jim'
    last_name = 'Bob'
    password = 'password'
    password_confirmation = 'password'

    visit '/'

    click_on 'Sign In'

    expect(current_path).to eq(login_path)

    click_on 'Sign up now.'

    expect(current_path).to eq(new_user_path)

    fill_in 'user[email]', with: email
    fill_in 'user[first_name]', with: first_name
    fill_in 'user[last_name]', with: last_name
    fill_in 'user[password]', with: password
    fill_in 'user[password_confirmation]', with: password

    click_on'Create Account'

    expect(current_path).to eq(dashboard_path)

    expect(page).to have_content(email)
    expect(page).to have_content(first_name)
    expect(page).to have_content(last_name)
    expect(page).to_not have_content('Sign In')
  end

  it 'unless their email address is already registered' do
    email = 'jimbob@aol.com'
    first_name = 'Jim'
    last_name = 'Bob'
    password = 'password'
    password_confirmation = 'password'

    User.create(email: email,
                 first_name: first_name,
                 last_name: last_name,
                 password:  password)

   visit '/'
   click_on 'Sign In'
   click_on 'Sign up now.'
   fill_in 'user[email]', with: email
   fill_in 'user[first_name]', with: first_name
   fill_in 'user[last_name]', with: last_name
   fill_in 'user[password]', with: password
   fill_in 'user[password_confirmation]', with: password
   click_on'Create Account'

   expect(current_path).to eq(new_user_path)
   expect(page).to have_content('Username already exists')
  end
end
