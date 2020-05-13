require 'rails_helper'

feature "An admin can delete a tutorial" do
  scenario "and it should no longer exist" do
    admin = create(:admin)
    create_list(:tutorial, 2)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit "/admin/dashboard"

    expect(page).to have_css('.admin-tutorial-card', count: 2)

    within(first('.admin-tutorial-card')) do
      click_link 'Delete'
    end

    expect(page).to have_css('.admin-tutorial-card', count: 1)
  end
  
  scenario "and its videos should not longer exist", :vcr do
    admin = create(:admin)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit '/admin/tutorials/new'
    click_link 'Import YouTube Playlist'
    fill_in 'Title', with: 'Animals Making Football Predictions'
    fill_in 'Description', with: "Yeah. It's exactly what it sounds like. What a world we live in."
    fill_in 'Playlist', with: 'PLbpi6ZahtOH5NpWaK0akzu0Pgley4eEXH'
    click_on 'Save'
    
    expect(current_path).to eq('/admin/dashboard')
    expect(Video.last.tutorial_id).to eq(Tutorial.last.id)
    
    within(first('.admin-tutorial-card')) do
      click_link 'Delete'
    end

    expect(Tutorial.last).to eq(nil)
    expect(Video.last).to eq(nil)
  end
end
