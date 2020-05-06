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
    save_and_open_page
  end
end
