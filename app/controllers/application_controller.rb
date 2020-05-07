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
