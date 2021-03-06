class Admin::TutorialsController < Admin::BaseController
  def edit
    @tutorial = Tutorial.find(params[:id])
  end

  def create
    tutorial = Tutorial.create(tutorial_params)
    if tutorial.save && tutorial_params[:playlist_id]
      create_and_link_playlist_videos(tutorial_params, tutorial)
    elsif tutorial.save
      flash[:success] = 'Successfully created tutorial.'
      redirect_to "/tutorials/#{tutorial.id}"
    else
      flash[:error] = 'Your tutorial was not created. Please try again.'
      redirect_to '/admin/tutorials/new'
    end
  end

  def new
    @tutorial = Tutorial.new
  end

  def update
    tutorial = Tutorial.find(params[:id])
    if tutorial.update(tutorial_params)
      flash[:success] = "#{tutorial.title} tagged!"
    end
    redirect_to edit_admin_tutorial_path(tutorial)
  end

  def destroy
    tutorial = Tutorial.find(params[:id])
    flash[:success] = "#{tutorial.title} tagged!" if tutorial.destroy
    redirect_to admin_dashboard_path
  end

  private

  def tutorial_params
    params.require(:tutorial).permit(:tag_list, :title,
                                     :description, :playlist_id, :thumbnail)
  end

  def create_and_link_playlist_videos(tutorial_params, tutorial)
    yt = YoutubeResults.new
    yt.create_tutorial_playlist(tutorial_params[:playlist_id], tutorial)
    redirect_path = "/tutorials/#{tutorial.id}"
    flash[:success] = "Successfully created tutorial.
                      #{view_context.link_to 'View it here', redirect_path}."
    redirect_to '/admin/dashboard'
  end
end
