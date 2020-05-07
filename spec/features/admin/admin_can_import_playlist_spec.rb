require 'rails_helper'

describe "An Admin can import a playlist" do
  let(:admin)    { create(:admin) }

  scenario "and it should create a tutorial" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit '/admin/tutorials/new'
    click_link 'Import YouTube Playlist'

    expect(current_path).to eq('/admin/playlist/new')

    fill_in 'Title', with: 'Animals Making Football Predictions'
    fill_in 'Description', with: "Yeah. It's exactly what it sounds like. What a world we live in."
    fill_in 'Playlist', with: 'PLbpi6ZahtOH5NpWaK0akzu0Pgley4eEXH'
    click_on 'Save'
    tutorial = Tutorial.last

    expect(current_path).to eq('/admin/dashboard')
    expect(page).to have_content('Successfully created tutorial. View it here.')

    click_link 'View it here'
    expect(current_path).to eq("/tutorials/#{tutorial.id}")
  end

  scenario "and import should create video records linked to the tutorial" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit '/admin/tutorials/new'
    click_link 'Import YouTube Playlist'
    fill_in 'Title', with: 'Animals Making Football Predictions'
    fill_in 'Description', with: "Yeah. It's exactly what it sounds like. What a world we live in."
    fill_in 'Playlist', with: 'PLbpi6ZahtOH5NpWaK0akzu0Pgley4eEXH'
    click_on 'Save'

    expect(Video.last.tutorial_id).to eq(Tutorial.last.id)
  end

  scenario "and it can contain >50 videos" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    visit '/admin/tutorials/new'
    click_link 'Import YouTube Playlist'
    fill_in 'Title', with: '100 Greatest Punk Songs of All Time'
    fill_in 'Description', with: "Fingers crossed there's nothing terribly offensive in here because I'm not watching all these videos."
    fill_in 'Playlist', with: 'PL0tDb4jw6kPy5q-S59cdj3RumlY1ah4S2'
    click_on 'Save'
    click_link 'View it here'
  end
end
