class Friend < ApplicationRecord
  belongs_to :user
  belongs_to :user_friend, class_name: 'User'

  validates :user, presence: true
  validates :user_friend, presence: true
end
