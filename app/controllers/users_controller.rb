class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    #  debugger - commented out 7.1.4
  end
  
  def create 
    @user = User.new(user_params)
      if @user.save # If @user.save = true then...
        flash[:success] = "You logged in! Welcome to my app" # Anything you place in the flash will be exposed to the 
        # very next action and then cleared out. This is a great way of doing notices and alerts.
        log_in @user #Log the user in so that the redirect takes them to their profile
        redirect_to @user # Equivalent to redirect_to user_url(@user) but inferred by rails
      else
        render 'new'
      end
  end
    
  private
    
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation) 
    end
    
end
