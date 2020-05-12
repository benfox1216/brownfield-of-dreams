class GithubData
  attr_reader :name, :url

  def initialize(name, url)
    @name = name
    @url = url
  end

  def database_match(user_name)
    user = User.where(github_username: user_name).first
    user.id if user
  end
end
