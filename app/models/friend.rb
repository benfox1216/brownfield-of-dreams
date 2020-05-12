class Friend < ApplicationRecord
  belongs_to :user
  belongs_to :follow_user, class_name: 'User'
  validate :realism

  private

  def realism
    return unless user_id == followed_user_id
    errors.add :user, 'You can not befriend yourself. Go meet someone.'
  end
end
