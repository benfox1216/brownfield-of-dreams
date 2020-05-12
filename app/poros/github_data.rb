class GithubData
  attr_reader :name, :url

  def initialize(name, url)
    @name = name
    @url = url
  end

  def database_match(current_user, user_name)
    user = User.where(github_username: user_name).first
    user.id if user && existing_friendship_check(current_user, user) == []
  end

  private

  def existing_friendship_check(current_user, user)
    Friend.where(user: current_user, user_friend: user)
  end
end
