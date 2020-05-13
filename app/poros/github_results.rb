class GithubResults
  def initialize(current_user)
    @current_user = current_user
  end

  def display_github_data(type)
    data = call_github_service(type, @current_user)
    return if data.class == Hash

    data = data[0..4] if type == 'repos'

    name = type == 'repos' ? 'name' : 'login'

    display_data = []
    data.each do |datum|
      display_data << GithubData.new(datum[name], datum['html_url'])
    end
    display_data
  end

  def find_github_user(username)
    data = call_github_service("users/#{username}", @current_user)
    data[:email]
  end

  private

  def call_github_service(uri, user)
    gh = GithubService.new
    gh.github_json(uri, user.token)
  end
end
