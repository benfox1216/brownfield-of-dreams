class GithubInvitationMailer < ApplicationMailer
  def inform(inviter_name, invitee_name, invitee_email)
    @inviter_name = inviter_name
    @invitee_name = invitee_name
    @invitee_email = invitee_email
    mail(to: @invitee_email,
         subject: 'You have been invited to join Dreamy Brownfield!')
  end
end
