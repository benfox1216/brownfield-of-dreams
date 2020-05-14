class UserVideo < ApplicationRecord
  belongs_to :video
  belongs_to :user

  def self.tutorials_with_videos
    all.map do |user_video|
      Tutorial.find(user_video.video.tutorial_id)
    end.uniq
  end
end
