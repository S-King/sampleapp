class AccountActivationController < ApplicationController

# Created by rails generate controller AccountActivation --no-test-framework
# Modelling activations as resource even though we don't have an (Active Record) model for them
# Since we put the relevant data (token/digest) in the User model and we have standar REST actions/urls
# .find(email: params[:email]) 

    def edit
        user = User.find_by(email: params[:email]) # look up user in active record by params hash
            if user && !user.activated? && user.authenticated?(:activation, params[:id]) # If user exists, is not active, and the activation token is authenticated then...
                user.activate
                log_in(user)
                flash[:success] = "Your account is now active, have fun!"
                redirect_to user # Rails knows this is the users page, user_path(user)
            else
                flash[:danger] = "Invalid activation link!"
                redirect_to root_url
            end
    end
end
