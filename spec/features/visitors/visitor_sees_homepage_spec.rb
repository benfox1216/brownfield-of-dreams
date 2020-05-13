require 'rails_helper'

describe 'Visitor' do
  describe 'on the home page' do
    it 'can see a list of tutorials' do
      tutorial1 = create(:tutorial)
      tutorial2 = create(:tutorial)

      video1 = create(:video, tutorial_id: tutorial1.id)
      video2 = create(:video, tutorial_id: tutorial1.id)
      video3 = create(:video, tutorial_id: tutorial2.id)
      video4 = create(:video, tutorial_id: tutorial2.id)

      visit root_path

      expect(page).to have_css('.tutorial', count: 2)

      within(first('.tutorials')) do
        expect(page).to have_css('.tutorial')
        expect(page).to have_css('.tutorial-description')
        expect(page).to have_content(tutorial1.title)
        expect(page).to have_content(tutorial1.description)
      end
    end
  end

  describe 'on the about page' do
    it 'can see some info' do
      visit '/about'
      expect(page).to have_content("This application is designed to pull in youtube information to populate tutorials from Turing School of Software and Design's youtube channel. It's designed for anyone learning how to code, with additional features for current students.")
    end
  end

  describe 'on the get started page' do
    it 'can see some info' do
      visit '/get_started'
      expect(page).to have_content("Browse tutorials from the homepage.")
      expect(page).to have_content("Filter results by selecting a filter on the side bar of the homepage.")
      expect(page).to have_content("Register to bookmark segments.")
      expect(page).to have_content("Sign in with census if you are a current student for addition content.")
    end
  end
end
