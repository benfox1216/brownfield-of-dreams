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

  def all_repos
    Faraday.get('https://api.github.com/user/repos') do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{current_user.token}"
    end
  end

  def display_repos
    repos = JSON.parse(all_repos.body)
    return if repos.class != Array

    count = 0
    max = repos.length < 5 ? repos.length : 5
    display_repos = []
    while count < max
      display_repos << Repo.new(repos[count]['name'], repos[count]['html_url'])
      count += 1
    end
    display_repos
  end
end
