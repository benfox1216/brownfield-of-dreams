class FriendsController < ApplicationController
  def create
    new_friend = Friend.create(friend_params)
    if !new_friend.save
      flash[:error] = 'This friendship cannot be created.'
    end
    redirect_to '/dashboard'
  end

  private

  def friend_params
    params.permit(:user_id, :user_friend_id)
  end
end
