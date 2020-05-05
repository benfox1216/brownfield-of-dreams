class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :find_bookmark
  helper_method :list_tags
  helper_method :tutorial_name
  helper_method :get_repos

  add_flash_types :success

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def find_bookmark(id)
    current_user.user_videos.find_by(video_id: id)
  end

  def tutorial_name(id)
    Tutorial.find(id).title
  end

  def four_oh_four
    raise ActionController::RoutingError, 'Not Found'
  end

  def get_repos
    all_repos = Faraday.get('https://api.github.com/user/repos' ) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{current_user.token}"
    end
    repo_data = JSON.parse(all_repos.body)
    counter = 0
    max = repo_data.length < 5 ? repo_data.length : 5
    repos_to_display = []
    while counter < max
      repos_to_display << Repo.new(repo_data[counter])
      counter += 1
    end
    repos_to_display
  end

end
