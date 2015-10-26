class SessionsController < ApplicationController
# Create, Destroy    
    
  def new
  end
  
=begin 
The find method is usually used to retrieve a row by ID --> Model.find(1)
Other uses of find are usually replaced with things like this --> Model.all, Model.first
Find_by is used as a helper when you're searching for information within a column, and it maps to such with naming conventions.
For instance, if you have a column named name in your database, you'd use the following syntax --> Model.find_by_name("Bob")
find_by is not deprecated, but the syntax is changing a bit. From find_by_name("Bob") to find_by(:name, "Bob")
.where is more of a catch all that lets you use a bit more complex logic for when the conventional helpers won't do.
=end

  def create
#Using string interpolation like User.where("email = #{SQL Injection") is vulnerable to SQL injection
    @user = User.find_by(email: params[:session][:email].downcase)
      if @user && @user.authenticate(params[:session][:password])
        #^ If the user is valid and we can authenticate the nested {session:{password: "sdfsd", email: "asdas" }} hash then create
        # has_secure_password automatically adds an authenticate method to the corresponding model objects. Makes sure password matches
        if @user.activated?
          log_in @user
          params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
          #^ uses ternary operator -> if_this_is_a_true_value ? then_the_result_is_this : else_it_is_this
          redirect_back_or @user #Rails converts this to redirect_to user_url(user)
        else
          flash[:warning] = "Account not activated, check your email."
          redirect_to root_url
        end
      else
      #^ if we can't create a new session go back to the new session/login screen
        flash.now[:danger] = 'Invalid email/password combination' #flash.now will flash at every render, not just every request
        render 'new' #Re-rendering a new page doesn't count as a request, thus flash will not continue to work here
                     #the flash would persist for one more request (page-click) 
      end
  end
  

  def destroy #Putting the session delete directly in destroy since we will only use it here
            #unlike when we use login ie. in creating users and creating sessions (logging in)
    log_out if logged_in?
    redirect_to root_url #Fully qualified URLs are required by HTTP when doing redirects
  end
  
end
