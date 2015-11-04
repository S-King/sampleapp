class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper #in our helpers
  # SessionHelper is a module for packaging large numbers of functions
  # across multiple views and controllers
  
    #Confirms that a user is logged in
  def logged_in_user
    unless logged_in? #Unless a user is logged in, run this loop
      store_location
      flash[:danger] = "Please log in to access this material." #Flash warning
      redirect_to login_url #Go to login path
    end
  end
end
