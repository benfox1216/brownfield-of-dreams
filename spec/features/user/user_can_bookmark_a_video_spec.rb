require 'rails_helper'

describe 'A registered user' do
  before :each do
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end
  
  it 'can add videos to their bookmarks' do
    tutorial= create(:tutorial, title: "How to Tie Your Shoes")
    video = create(:video, title: "The Bunny Ears Technique", tutorial: tutorial)

    visit tutorial_path(tutorial)

    expect {
      click_on 'Bookmark'
    }.to change { UserVideo.count }.by(1)

    expect(page).to have_content("Bookmark added to your dashboard")
  end

  it "can't add the same bookmark more than once" do
    tutorial= create(:tutorial)
    video = create(:video, tutorial_id: tutorial.id)

    visit tutorial_path(tutorial)

    click_on 'Bookmark'
    expect(page).to have_content("Bookmark added to your dashboard")
    click_on 'Bookmark'
    expect(page).to have_content("Already in your bookmarks")
  end
  
  it "can see their bookmarks displayed" do
    tutorial_1 = create(:tutorial)
    tutorial_2 = create(:tutorial)
    tutorial_3 = create(:tutorial)
    
    video_1 = create(:video, title: "Test 1", tutorial_id: tutorial_1.id, position: 2)
    video_2 = create(:video, title: "Test 2", tutorial_id: tutorial_2.id, position: 2)
    video_3 = create(:video, title: "Test 3", tutorial_id: tutorial_1.id, position: 3)
    video_4 = create(:video, title: "Test 4", tutorial_id: tutorial_2.id, position: 3)
    video_5 = create(:video, title: "Test 5", tutorial_id: tutorial_1.id, position: 1)
    video_6 = create(:video, title: "Test 6", tutorial_id: tutorial_2.id, position: 1)
    
    visit tutorial_path(tutorial_2)
    click_link 'Test 2'
    click_on 'Bookmark'

    visit tutorial_path(tutorial_1)
    click_link 'Test 1'
    click_on 'Bookmark'

    visit tutorial_path(tutorial_2)
    click_link 'Test 4'
    click_on 'Bookmark'

    visit tutorial_path(tutorial_1)
    click_link 'Test 3'
    click_on 'Bookmark'

    visit '/dashboard'
    
    within(".tutorial-#{tutorial_1.id}") do
      expect(page).to have_content("#{tutorial_1.title}")
      expect(page).to have_link("#{video_1.title}")
      expect(page).to have_link("#{video_3.title}")
      
      expected_array = [video_1.title, video_3.title]
      expect(page.all(:link).map {|link| link.text}).to eq(expected_array)
      
      expect(page).to_not have_link("#{video_5.title}")
    end
    
    within(".tutorial-#{tutorial_2.id}") do
      expect(page).to have_content("#{tutorial_2.title}")
      expect(page).to have_link("#{video_2.title}")
      expect(page).to have_link("#{video_4.title}")
      expect(page).to_not have_link("#{video_6.title}")
    end
    
    expect(page).to_not have_css(".tutorial-#{tutorial_3.id}")
  end
end
