class GithubService

  def github_json(uri, token)
    JSON.parse(github_response(uri, token).body)
  end

  private

  def github_response(uri, token)
    Faraday.get("https://api.github.com/user/#{uri}") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{token}"
    end
  end
end
