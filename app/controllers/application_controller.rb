class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper #in our helpers
  # SessionHelper is a module for packaging large numbers of functions
  # across multiple views and controllers
end
