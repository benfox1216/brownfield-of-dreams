require 'rails_helper'

feature "An admin" do
  scenario "can create a new tutorial", :vcr do
    admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit "/admin/tutorials/new"

    fill_in 'Title', with: "Let's Build: with Ruby on Rails"
    fill_in 'Description', with: "Build some Rails apps."
    fill_in 'Thumbnail', with: 'https://img.youtube.com/vi/NDjNX3nEfYo/0.jpg'

    click_on 'Save'
    tutorial = Tutorial.last

    expect(current_path).to eq("/tutorials/#{tutorial.id}")
    expect(page).to have_content("Successfully created tutorial.")
  end

  scenario "gets redirected if a tutorial doesn't save", :vcr do
    admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    bad_params = {"title"=>nil, "description"=>nil, "thumbnail"=>nil}
    allow_any_instance_of(Admin::TutorialsController).to receive(:tutorial_params).and_return(bad_params)

    visit "/admin/tutorials/new"

    fill_in 'Title', with: "Let's Build: with Ruby on Rails"
    fill_in 'Description', with: "Build some Rails apps."
    fill_in 'Thumbnail', with: 'https://img.youtube.com/vi/NDjNX3nEfYo/0.jpg'

    click_on 'Save'

    expect(current_path).to eq("/admin/tutorials/new")
    expect(page).to have_content("Your tutorial was not created. Please try again.")
  end
end
