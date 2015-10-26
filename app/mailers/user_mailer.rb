class UserMailer < ApplicationMailer
# Created with rails generate mailer UserMailer account_activation password_reset
# with default methods for account_activation and password_reset
# Also creates two views for each mailer, plaintext and HTML, .text.erb and .HTML.erb

#UserMailer uses the Action Mailer library which we use in Users#create to send the email
#Mailers are structured much like controller actions, with email templates defined as views.

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user) # Pass in the user to send to
  # Can be passed both instance variables and local
  # Activation link will look like http://www.example.com/account_activations/ACTIVATION-TOKEN/edit
    @user = user # Instance variable must be created for use the view
    mail to: user.email, subject: "#{user.name}'s Account Activation Information"
  end

  def password_reset
    @greeting = "Hi"
    mail to: "to@example.org"
  end
end
