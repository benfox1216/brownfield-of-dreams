class InvitesController < ApplicationController
  def new; end

  def create
    gh_user = find_github_username(invite_params[:github_handle])
    if gh_user
      send_email(current_user[:github_username],
                 invite_params[:github_handle], gh_user)
      flash[:success] = 'Successfully sent invite!'
    else
      flash[:error] = "The Github user you selected doesn't have an email
                      address associated with their account."
    end
    redirect_to dashboard_path
  end

  private

  def send_email(inviter, invitee_name, invitee_email)
    GithubInvitationMailer.inform(inviter, invitee_name, invitee_email)
                          .deliver_now
  end

  def find_github_username(username)
    gh = GithubResults.new(current_user)
    gh.find_github_user(username)
  end

  def invite_params
    params.permit(:github_handle)
  end
end
