class Tutorial < ApplicationRecord
  has_many :videos, -> { order(position: :ASC) },
           inverse_of: :tutorial,
           dependent: :destroy
  validates :title, presence: true
  validates :description, presence: true
  acts_as_taggable_on :tags, :tag_list
  accepts_nested_attributes_for :videos

  def self.get_welcome_videos(tag, page, user)
    if tag
      param_tagged_videos(tag, page)
    elsif !user
      non_classroom_videos(page)
    else
      all_videos(page)
    end
  end

  def self.non_classroom_videos(page)
    Tutorial.all.where('classroom = false').paginate(page: page, per_page: 5)
  end

  def self.param_tagged_videos(tag, page)
    Tutorial.tagged_with(tag).paginate(page: page, per_page: 5)
  end

  def self.all_videos(page)
    Tutorial.all.paginate(page: page, per_page: 5)
  end
end
