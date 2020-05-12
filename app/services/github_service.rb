class GithubService
  def github_json(uri, token)
    github_parse(uri, token)
  end

  private

  def github_response(uri, token)
    uri = "/#{uri}" unless uri == ""
    Faraday.get("https://api.github.com/user#{uri}") do |req|
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{token}"
    end
  end

  def github_parse(uri, token)
    JSON.parse(github_response(uri, token).body)
  end
end
