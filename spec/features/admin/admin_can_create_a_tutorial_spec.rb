require 'rails_helper'

feature "An admin" do
  scenario "can create a new tutorial" do
    admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit "/admin/tutorials/new"
    
    fill_in 'Title', with: 'A Meaningful Name'
    fill_in 'Description', with: "Some content."
    fill_in 'Thumbnail', with: 'https://www.youtube.com/watch?v=IUjf1lVOGOo'
    
    click_on 'Save'
  end
end