class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :find_bookmark
  helper_method :list_tags
  helper_method :tutorial_name
  helper_method :display_repos
  helper_method :display_follow

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

  def access_github_data(uri)
    response = Faraday.get("https://api.github.com/user/#{uri}") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{current_user.token}"
    end
    JSON.parse(response.body)
  end

  def display_repos
    repos = access_github_data('repos')
    return if repos.class == Hash

    count = 0
    max = repos.length < 5 ? repos.length : 5
    display_repos = []
    while count < max
      display_repos << Repo.new(repos[count]['name'], repos[count]['html_url'])
      count += 1
    end
    display_repos
  end

  def display_follow(ing_or_ers)
    follows = access_github_data(ing_or_ers)
    return if follows.class == Hash

    display_follows = []
    follows.each do |follower|
      display_follows << Follow.new(follower['login'], follower['html_url'])
    end
    display_follows
  end
end
