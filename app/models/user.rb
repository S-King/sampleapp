class User < ActiveRecord::Base
    attr_accessor :remember_token # Virtual attribute for storing in cookies
    
    before_save { self.email = email.downcase } # here we are passing a block, inside the user model/class using self is optional on the right side ie. self.email.downcase
    # ^^ however, self must be used for assignments so it must be on the left side
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    validates :name, presence: true, length: {maximum: 50} # equal to validates(:name, presence: true)
    
        Valid_email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i  
    validates :email, presence: true, length: {maximum:255}, 
        format: { with: Valid_email_regex }, # Weakness of this regex is that it allows consecutive periods: foo@bar...com
        uniqueness: { case_sensitive: false } # Rails infers that :uniqueness is true with this option
        
    #Includes a validation preventing nil passwords so we can test using ""
    has_secure_password # READ UP ON THIS
    
    def User.digest(password_string) 
        # Class methods can also be defined using self.digest or class << self with the method nested
        # Using this we can call the method on a class rather than the instance of a class
        # Were using this digest method to create encrypted passwords we can use in fixtures for tests requiring logged in users
        # a digested password is required for use by the has_secure_password method of BCrypt
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(password_string, cost: cost)
    end
    
    def User.new_token 
        SecureRandom.urlsafe_base64 # returns a random string of length 22 composed of 
            #the characters A–Z, a–z, 0–9, “-”, and “_”. Part of Ruby's standard library
    end
    
    def remember # Instance method used for adding remember tokens to cookies
    # Self ensures we associate the token with a specific user otherwise it would save an unassociated local variable
        self.remember_token = User.new_token # Creates a 22 digit token
        update_attribute(:remember_digest, User.digest(remember_token)) #this method bypasses validations since we dont yet have access to the user's
            #password or confirmation
    end
    
    def forget #updates our :remember_digest to nil to log out
        update_attribute(:remember_digest, nil)
    end
    
    def authenticated?(remember_token)
        #remember_token is a local variable, not the same as the :remember_token defined with attr_accessor
        #remember_digest attribute is automatically created since the name matches the database column we created
        return false if remember_digest.nil? #Using return short circuits the method to not evaluate the rest
        BCrypt::Password.new(remember_digest).is_password?(remember_token) 
    end
    
end