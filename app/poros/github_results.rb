class GithubResults

  def initialize(current_user)
    @current_user = current_user
  end

  def display_repos
    gh = GithubService.new
    repos = gh.github_json('repos', @current_user.token)
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
    follows = gh.github_json(ing_or_ers, @current_user.token)
    return if follows.class == Hash

    display_follows = []
    follows.each do |follower|
      display_follows << Follow.new(follower['login'], follower['html_url'])
    end
    display_follows
  end
end
