class YoutubeResults
  def create_tutorial_playlist(id, tutorial)
    access_youtube_playlist(id).each do |item|
      create_video_from_playlist(item, tutorial)
    end
  end

  def access_youtube_playlist(id)
    yt = YoutubeService.new
    items = yt.playlist_info(id)
    items[:items]
  end

  def create_video_from_playlist(item, tutorial)
    id = item[:contentDetails][:videoId]
    video = YouTube::Video.detail_lookup(id)
    new_video =
      tutorial.videos.new(video_id: id,
                          title: video[:items][0][:snippet][:title],
                          description: video[:items][0][:snippet][:description],
                          thumbnail: YouTube::Video.by_id(id).thumbnail)
    new_video.save
  end
end
