class FriendsController < ApplicationController
  def create
    Friend.create(friend_params)
    redirect_to '/dashboard'
  end

  private

  def friend_params
    params.permit(:user_id, :user_friend_id)
  end
end
