class RegistrationEmailerMailer < ApplicationMailer
  def inform(user)
    @user = user
    @message = 'Visit here to activate your account.'
    mail(to: user[:email], subject: 'Activate your account.')
  end
end
