class UsersController < ApplicationController
  def show
    @github = GithubResults.new(current_user)
  end

  def new
    @user = User.new
  end

  def create
    user = User.create(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      flash[:error] = 'Username already exists'
      render :new
    end
  end

  def update
    if request.env['omniauth.auth'] &&
       request.env['omniauth.auth']['credentials']
      current_user.update(token:
                          request.env['omniauth.auth']['credentials']['token'])
      if current_user.save
        current_user.update(github_username:
                            update_github_username['login'])
        current_user.save
      end
      @current_user.reload
    end
    redirect_to dashboard_path
  end

  private

  def update_github_username
    gh = GithubResults.new(current_user)
    gh.display_github_data("user")
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password)
  end
end
