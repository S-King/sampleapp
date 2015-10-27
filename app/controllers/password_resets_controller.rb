class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email]) #Look up user in nested hash
    # :password_reset from form then :email from password_reset
      if @user # If user is valid
        @user.create_reset_digest
        @user.send_password_reset_email
        flash[:info] = "Email sent to #{@user.email} with password reset instructions."
      redirect_to root_url
      else
        flash[:danger] = "Email not found."
        render 'new'
      end
  end
  
  def edit
    
  end
  
  def update
    if params[:user][:password].empty?
        @user.errors.add(:password, "Password can't be empty")
        render 'edit'
      elsif @user.update_attributes(user_params)
        log_in @user
        flash[:success] = "Password Updated Successfully"
        redirect_to @user
      else
        render 'edit'
    end
  end
  
private
  
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  
# Before Filters 

  def get_user
    @user = User.find_by(email: params[:email])
  end
  
  def valid_user 
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end
  
  def check_expiration # Check expiration of reset token
    if @user.password_reset_expired?
      flash[:danger] = "Password reset link has expired"
      redirect_to new_password_reset_url
    end
  end
  
end
