class YoutubeResults
  def create_tutorial_playlist(id, tutorial)
    create_playlist_videos(id, tutorial)
  end

  private

  def create_playlist_videos(id, tutorial)
    access_youtube_playlist(id).each do |item|
      create_video_from_playlist(item, tutorial)
    end
  end

  def access_youtube_playlist(id, page = nil, items = [])
    yt = YoutubeService.new
    videos = yt.playlist_info(id, page)
    items << videos[:items]
    if videos[:nextPageToken]
      access_youtube_playlist(id, videos[:nextPageToken], items)
    end
    items.flatten
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
