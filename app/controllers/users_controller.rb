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
      send_registration_email(user)
      session[:user_id] = user.id
      flash[:success] = registration_success(user)
      redirect_to dashboard_path
    else
      flash[:error] = 'Username already exists'
      redirect_to new_user_path
    end
  end

  def update
    if request.env['omniauth.auth'] &&
       request.env['omniauth.auth']['credentials']
      current_user.update(token:
                          request.env['omniauth.auth']['credentials']['token'],
                          github_username: update_github_username)
      current_user.save
      @current_user.reload
    end
    redirect_to dashboard_path
  end

  private

  def update_github_username
    gh = GithubResults.new(current_user)
    gh.display_github_user_info
  end

  def send_registration_email(user)
    RegistrationEmailerMailer.inform(user).deliver_now
  end

  def registration_success(user)
    "Logged in as #{user.first_name} #{user.last_name}.
     This account has not yet been activated. Please check your email."
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password)
  end
end
