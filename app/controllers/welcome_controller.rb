class WelcomeController < ApplicationController
  def index
    # @tutorials = if params[:tag]
    #                Tutorial.tagged_with(params[:tag])
    #                        .paginate(page: params[:page], per_page: 5)
    #              elsif !current_user
    #                Tutorial.non_classroom_videos.paginate(page: params[:page], per_page: 5)
    #              else
    #                Tutorial.all.paginate(page: params[:page], per_page: 5)
    #              end
    @tutorials = Tutorial.get_welcome_videos(params[:tag], params[:page], current_user)

  end
end
