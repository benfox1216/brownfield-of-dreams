require 'rails_helper'

describe 'visitor cannot see classroom content ' do
  before (:each) do
    @tutorial_1 = Tutorial.create(
      title: "Back End Engineering - Prework",
      description: "Videos for prework.",
      thumbnail: "https://i.ytimg.com/vi/qMkRHW9zE1c/hqdefault.jpg",
      playlist_id: "PL1Y67f0xPzdN6C-LPuTQ5yzlBoz2joWa5",
      classroom: false
    )
    @tutorial_2 = Tutorial.create(
      title: "Back End Engineer - Classroom Content",
      description: "Seems eerily similar to prework videos.",
      thumbnail: "https://i.ytimg.com/vi/qMkRHW9zE1c/hqdefault.jpg",
      playlist_id: "PL1Y67f0xPzdN6C-LPuTQ5yzlBoz2joWa5",
      classroom: true
    )
  end

  it 'on the homepage' do
    visit "/"

    expect(page).to have_link("Back End Engineering - Prework")
    expect(page).to have_content("Videos for prework.")
    expect(page).to_not have_link("Back End Engineer - Classroom Content")
    expect(page).to_not have_content("Seems eerily similar to prework videos.")
  end

  it 'unless they log in' do
    user = create(:user)
    visit '/'
    click_on "Sign In"
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    click_on 'Log In'
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit '/'

    expect(page).to have_link("Back End Engineering - Prework")
    expect(page).to have_content("Videos for prework.")
    expect(page).to have_link("Back End Engineer - Classroom Content")
    expect(page).to have_content("Seems eerily similar to prework videos.")
  end
end
