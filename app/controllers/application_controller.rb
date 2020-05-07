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

  # def access_github_data(uri)
  #   response = Faraday.get("https://api.github.com/user/#{uri}") do |req|
  #     req.headers['Content-Type'] = 'application/json'
  #     req.headers['Authorization'] = "Bearer #{current_user.token}"
  #   end
  #   JSON.parse(response.body)
  # end

  def display_repos
    gh = GithubService.new
    repos = gh.github_json('repos', current_user.token)
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
    gh = GithubService.new
    follows = gh.github_json(ing_or_ers, current_user.token)
    return if follows.class == Hash

    display_follows = []
    follows.each do |follower|
      display_follows << Follow.new(follower['login'], follower['html_url'])
    end
    display_follows
  end

  def access_youtube_playlist(id)
    url = 'https://www.googleapis.com/youtube/v3/playlistItems'
    response = Faraday.get(url) do |req|
      req.headers['Content-Type'] = 'application/json'
      req.params['key'] = ENV['YOUTUBE_API_KEY']
      req.params['playlistId'] = id
      req.params['part'] = 'contentDetails'
    end
    items = JSON.parse(response.body)
    items['items']
  end

  def create_video_from_playlist(item, tutorial)
    id = item['contentDetails']['videoId']
    video = YouTube::Video.detail_lookup(id)
    new_video =
      tutorial.videos.new(video_id: id,
                          title: video[:items][0][:snippet][:title],
                          description: video[:items][0][:snippet][:description],
                          thumbnail: YouTube::Video.by_id(id).thumbnail)
    new_video.save
  end

  def create_tutorial_playlist(id, tutorial)
    access_youtube_playlist(id).each do |item|
      create_video_from_playlist(item, tutorial)
    end
  end
end
