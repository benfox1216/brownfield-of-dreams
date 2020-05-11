class WelcomeController < ApplicationController
  def index
    @tutorials = Tutorial.get_welcome_videos(params[:tag],
                                             params[:page],
                                             current_user)
  end
end
