class FriendsController < ApplicationController
  def create
    new_friend = Friend.create(friend_params)
    flash[:error] = 'This friendship cannot be created.' unless new_friend.save
    redirect_to '/dashboard'
  end

  private

  def friend_params
    params.permit(:user_id, :user_friend_id)
  end
end
