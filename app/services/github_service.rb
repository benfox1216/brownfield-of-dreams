class GithubService
  def github_json(uri, token)
    github_parse(uri, token)
  end

  private

  def github_response(uri, token)
    uri = "user/#{uri}" unless uri.include?('user')
    Faraday.get("https://api.github.com/#{uri}") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{token}"
    end
  end

  def github_parse(uri, token)
    JSON.parse(github_response(uri, token).body)
  end
end
