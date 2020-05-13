require 'rails_helper'

RSpec.describe Tutorial, type: :model do
  describe 'relationships' do
    it { should have_many(:videos).dependent(:destroy)}
  end

  describe 'model methods' do
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
      @tutorial_3 = Tutorial.create(
        title: "Back End Engineering - Prework",
        description: "Videos for prework.",
        thumbnail: "https://i.ytimg.com/vi/qMkRHW9zE1c/hqdefault.jpg",
        playlist_id: "PL1Y67f0xPzdN6C-LPuTQ5yzlBoz2joWa5",
        classroom: false
      )
      @tutorial_4 = Tutorial.create(
        title: "Back End Engineer - Classroom Content",
        description: "Seems eerily similar to prework videos.",
        thumbnail: "https://i.ytimg.com/vi/qMkRHW9zE1c/hqdefault.jpg",
        playlist_id: "PL1Y67f0xPzdN6C-LPuTQ5yzlBoz2joWa5",
        classroom: true
      )
    end

    it '.non_classroom_videos' do
      videos = Tutorial.non_classroom_videos(nil)
      expect(videos.size).to eq(2)
      expect(videos[0]).to eq(@tutorial_1)
      expect(videos[-1]).to eq(@tutorial_3)
    end

    it '.all_videos' do
      videos = Tutorial.all_videos(nil)
      expect(videos.size).to eq(4)
      expect(videos[0]).to eq(@tutorial_1)
      expect(videos[1]).to eq(@tutorial_2)
      expect(videos[2]).to eq(@tutorial_3)
      expect(videos[3]).to eq(@tutorial_4)
    end

    it '.get_welcome_videos' do
      user = create(:user)
      videos_1 = Tutorial.get_welcome_videos(nil, nil, user)
      expect(videos_1.size).to eq(4)
      expect(videos_1[0]).to eq(@tutorial_1)
      expect(videos_1[1]).to eq(@tutorial_2)
      expect(videos_1[2]).to eq(@tutorial_3)
      expect(videos_1[3]).to eq(@tutorial_4)

      videos_2 = Tutorial.get_welcome_videos(nil, nil, nil)
      expect(videos_2.size).to eq(2)
      expect(videos_2[0]).to eq(@tutorial_1)
      expect(videos_2[-1]).to eq(@tutorial_3)
    end
  end
end
