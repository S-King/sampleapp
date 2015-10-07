module SessionsHelper
    #Helper methods not available in tests

=begin 
    -transient cookies, like the ones created with session are erased with the browser
        is closed and are secure because they are automatically encrypted
    -permanant cookies, like the ones created with the cookies method are persistent
        but vulnerable to session hijacking attacks. There are four main types:
        1. Packet sniffing: detecting cookies passed over unsecure networks
        2. Attacking a DB storing remember tokens
        3. Cross-Site Scripting (XSS): input validation issue that allows your site to run malicious code
            ie. if someone can input script code into your search field
        4. Physical access to a logged in machine
        
    How to prevent:
        1. Using Secure Socket Layer (SSL) site-wide to protect against packet sniffers
            -SSL Certificates have a key pair: a public and a private key. These keys work together to establish an encrypted connection.
            The certificate also contains what is called the “subject,” which is the identity of the certificate/website owner
        2. Only storing hash digests of the remember tokens, not the tokens in plain text
        3. Rails auto-prevents this by escaping any content inserted into view templates
        4. We minimize this by having changing tokens every time a user logs out and
            cryptographically signing all potentially sensitive information
=end
    
    def log_in(user)
        session[:user_id] = user.id
        # Cookies created using the session method
        # are automatically encrypted.
        #Cookies created using the cookies method aren't encrypted
        #and a vulnerable to a session hijacking attack
    end
    
    def remember(user)
        user.remember
        # Sets a signed cookie, which prevents users from tampering with its value.
        # The cookie is signed by your app's `secrets.secret_key_base` value.
        # It can be read using the signed method `cookies.signed[:name]`
        cookies.permanent.signed[:user_id] = user.id 
        cookies.permanent[:remember_token] = user.remember_token
    end
    
    def log_out
        forget(current_user)
        session.delete(:user_id)
        @current_user = nil
    end
    
    def forget(user) #kill a permanant session's info
        user.forget #sets :remember_digest to nil
        cookies.delete(:user_id) # Delete browser cookies
        cookies.delete(:remember_token)
    end
    
    def current_user #Returns current user logged in, if any, otherwise returns nil
        if (user_id = session[:user_id]) # Retrieve user from temporary session if it exists
            @current_user ||= User.find_by(id: user_id)
            # ||= is 'or equals' is equivalent to the += convention
        elsif (user_id = cookies.signed[:user_id]) #Otherwise return user from persistent session
            user = User.find_by(id: user_id)
            if user && user.authenticated?(cookies[:remember_token])
                log_in(user)
                @current_user = user
            end
        end

    end

    def logged_in? # Returns true if current user is logged in, otherwise false
                   # Question mark at the end of the method is just a code convention
                   # meaning this method will return boolean values
        !current_user.nil?
    end

end
