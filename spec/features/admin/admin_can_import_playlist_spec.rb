require 'rails_helper'

describe "An Admin can import a playlist" do
  let(:admin)    { create(:admin) }

  scenario "and it should create a tutorial", :vcr do
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

  scenario "and import should create video records linked to the tutorial", :vcr do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit '/admin/tutorials/new'
    click_link 'Import YouTube Playlist'
    fill_in 'Title', with: 'Animals Making Football Predictions'
    fill_in 'Description', with: "Yeah. It's exactly what it sounds like. What a world we live in."
    fill_in 'Playlist', with: 'PLbpi6ZahtOH5NpWaK0akzu0Pgley4eEXH'
    click_on 'Save'

    expect(Video.last.tutorial_id).to eq(Tutorial.last.id)
  end

  scenario "and it can contain >50 videos", :vcr do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    visit '/admin/tutorials/new'
    click_link 'Import YouTube Playlist'
    fill_in 'Title', with: 'Organizing For Power'
    fill_in 'Description', with: "Organizing is the lifeblood of our union. We run organizing drives all over the country to expand the ranks of our union and enforce the bargaining rights of our members through strategic campaigns."
    fill_in 'Playlist', with: 'PLzbIMRuULnI4n3dKdJk2fqKK8I7nAV4Ns'
    click_on 'Save'
    click_link 'View it here'

    expect(page).to have_link(Video.last.title)

    list = find('#video_list').all('li')
    expect(list.size).to eq(Tutorial.last.videos.count)
    expect(list.size).to be > 50
  end
end
