class User < ApplicationRecord
  has_many :user_videos, dependent: :destroy
  has_many :videos, through: :user_videos
  has_many :friends, dependent: :destroy
  has_many :user_friends, through: :friends
  has_many :frienders, dependent: :destroy,
                       foreign_key: :user_friend,
                       class_name: 'Friend',
                       inverse_of: :user_friend
  has_many :friender_users, through: :frienders, source: :user
  validates :email, uniqueness: true, presence: true
  validates :first_name, presence: true
  validates :password_digest, presence: true
  enum role: { default: 0, admin: 1 }
  has_secure_password
end
