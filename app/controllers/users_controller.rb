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
    if request.env['omniauth.auth']
      current_user.update(token: request.env['omniauth.auth']["credentials"]["token"])
      current_user.save
      @current_user.reload
    end
    redirect_to dashboard_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password)
  end
end
