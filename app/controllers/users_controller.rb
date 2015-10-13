class UsersController < ApplicationController 
#  Where we house all the actions for our resources
  #?? is the @user here only available to the other actions in this controller ??
  
  
  #Before filter to call a method before an action is called, by default these run before
  #every action in the  controller so we limit it to :edit and :update by passing the :only options hash
  #This checks that a user is logged in when trying to edit or update
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user,   only: [:edit, :update] 
  before_action :admin_user,     only: :destroy
  
  def new
    @user = User.new
  end
  
  #params hash holds all GET or POST parameters passed to the controller, as well as the :controller and :action keys.
  def show
    @user = User.find(params[:id])
    #  debugger - commented out 7.1.4
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def index
    @users = User.paginate( page: params[:page]) # Pull users from DB and store in @user
    #paginate method will automatically look for a @users objects in a users view and display links to other pages
    #takes hash argument with key :page and value of page number, :page = nil returns first page
    #Gets params[:page] from will_paginate
  end
  
  
  def update
    @user = User.find(params[:id])
       if @user.update_attributes(user_params) #Only update is user_params check out to true
        flash[:success] = "Update sucessful!" #Let them know updates were applied
        redirect_to @user #Go back to profile page after successful edit
       else
         render 'edit' #if edits weren't sucessfull then render the 'edit' view of users
       end
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
    
  def destroy
    @user = User.find(params[:id])
    deleteduser = @user.name
    User.find(params[:id]).destroy
    flash[:success] = "User #{deleteduser} has been deleted."
    redirect_to users_url # Must use urls in redirect_to
  # The delete method essentially deletes a row (or an array of rows) from the database. 
  # Destroy on the other hand allows for a few more options. First, it will check any callbacks 
  # such as before_delete, or any dependencies that we specify in our model. Next, it will keep
  # the object that just got deleted in memory; this allows us to leave a message saying something 
  # like “Order #{order.id} has been deleted.” Lastly, and most importantly, it will also delete 
  # any child objects associated with that object!
  end
    
  private
    
    def user_params #Using user_params with STRONG PARAMETERS prevents mass assignment vulnerability
    #Require a user and only permit the specified parameters in the hash
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    # Note that we don't include :admin in the permitted params so that someone can't hijack admin
    # with a request like patch /users/17?admin=1
    end
    
    
    # Before Filters 
    
    #Confirms that a user is logged in
    def logged_in_user
      unless logged_in? #Unless a user is logged in, run this loop
        store_location
        flash[:danger] = "Please log in to access this material." #Flash warning
        redirect_to login_url #Go to login path
      end
    end
    
    def correct_user
      @user = User.find(params[:id]) #Find user by id key
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
