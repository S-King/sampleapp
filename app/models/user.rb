class User < ActiveRecord::Base
# User.digest, User.new_token, remember, forget, authenticated?(remember_token)

    has_many :microposts, dependent: :destroy
    # When the foreign key for a User model object is user_id, Rails infers the association automatically: by default,
    # Rails expects a foreign key of the form <class>_id, where <class> is the lower-case version of the class name.
    has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
    has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
    # By default, in a has_many :through association Rails looks for a foreign key corresponding to the singular version of the association. 
    # With code like --> has_many :followeds, through: :active_relationships Rails would see “followeds” and use the singular “followed”, 
    # assembling a collection using the followed_id in the relationships table, user.followeds is rather awkward, naturally Rails allows us to override the default, 
    # in this case using the source parameter which explicitly tells Rails that the source of the following array is the set of followed ids.
    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships, source: :follower
    
# Virtual Attributes
    attr_accessor :remember_token, :activation_token, :reset_token # Virtual attribute for storing in cookies
    
#Before/After actions and Filters
    before_save { self.email = email.downcase } # here we are passing a block, inside the user model/class using self is optional on the right side ie. self.email.downcase
    # ^^ however, self must be used for assignments so it must be on the left side
    before_create :create_activation_digest # Before any user is created it needs an activation digest in the DB, called a Method Reference
    #Created users will automatically have the activation token/digest from callback and digest will be saved to DB
    
#Validations    
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
    validates :name, presence: true, length: {maximum: 50} # equal to validates(:name, presence: true)
        Valid_email_regex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i  
    validates :email, presence: true, length: {maximum:255}, 
        format: { with: Valid_email_regex }, # Weakness of this regex is that it allows consecutive periods: foo@bar...com
        uniqueness: { case_sensitive: false } # Rails infers that :uniqueness is true with this option
        
    has_secure_password
=begin
    Adds methods to set and authenticate against a BCrypt password. This mechanism requires you to have a password_digest attribute.
    Need to uncomment gem 'bcrypt-ruby', '~> 3.0.0' end enable
    Validations for presence of password, confirmation of password (using a “password_confirmation” attribute) are automatically added. You can add more validations by hand if need be.
    
    user = User.new(:name => "david", :password => "", :password_confirmation => "nomatch")
    user.save                                                      # => false, password required
    user.authenticate("notright")                                  # => false
    user.authenticate("mUc3m00RsqyRe")                             # => user
    User.find_by_name("david").try(:authenticate, "notright")      # => nil
    User.find_by_name("david").try(:authenticate, "mUc3m00RsqyRe") # => user
=end
    
    
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
    
    def authenticated?(attribute, token)
        # send method, which lets us call a method with a name of our choice
        digest = send("#{attribute}_digest") # Don't need self since inside User model
        #remember_token is a local variable, not the same as the :remember_token defined with attr_accessor
        #remember_digest attribute is automatically created since the name matches the database column we created
        return false if digest.nil? #Using return short circuits the method to not evaluate the rest
        # .new initializes a BCrypt::Password instance with the data from a stored hash.
        BCrypt::Password.new(digest).is_password?(token) # .is_password?(secret) 
    end
   
   def activate # Activates an account, used by account_activations_controller
   # We don't use the user variable inside the model bc there is no such variable here
    update_columns(activated: true, activated_at: Time.zone.now)
   end
   
   def send_activation_email
       UserMailer.account_activation(self).deliver_now
       #Moved user manipulation out of the controller and into the model
       #Switched from @user in the controller to self in the model
   end
   
   def create_reset_digest # Set the password reset virtual attribute
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
   end

    def send_password_reset_email # Sends the password reset email
        UserMailer.password_reset(self).deliver_now
    end
   
   def password_reset_expired?
       reset_sent_at < 2.hours.ago
   end
   
   # Defines proto-feed, see "Following Users" for full documentation
   def feed
    # Calls :id on each element in user.following
    # User.first.following.map { |user| user.id }
    # User.first.following.map(&:id) 
    # Active Record provides:
    # User.first.following_ids
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    # Use string interpolation for raw sql
    Micropost.where("user_id IN (#{following_ids})
        OR user_id = :user_id", user_id: id)
    # Using "X = ?", ? escapes out the id, preventing SQL injection
    # For high volume this would need to be converted to an a synchronous background job
   end
   
   def follow(other_user)
       active_relationships.create(followed_id: other_user.id)
   end
   
   def unfollow(other_user)
       active_relationships.find_by(followed_id: other_user.id).destroy
   end
   
   def following?(other_user) # Does the array of users this User follows include other_user?
      following.include?(other_user) 
   end
   
   
private # Hidden, private methods cannot be called with an explicit receiver by definition e.g. some_instance.private_method(value)
    
    #Should only be used internally by the User model
    def create_activation_digest # self is only used for assignments, hence
        self.activation_token = User.new_token
        self.activation_digest = User.digest(activation_token)
    end
   
    
end