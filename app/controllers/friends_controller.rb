class FriendsController < ApplicationController

  def create
    Friend.create(friend_params)
    redirect_to '/dashboard'
  end

  private


  def friend_params
    params.permit(:user_id, :follow_user_id)
  end
end
