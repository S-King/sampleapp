class User < ActiveRecord::Base
    before_save { self.email = email.downcase } # here we are passing a block, inside the user model/class using self is optional on the right side ie. self.email.downcase
    # ^^ however, self must be used for assignments so it must be on the left side
    
    validates :password, presence:true, length: { minimum: 6 }
    
    validates :name, presence: true, length: {maximum: 50} # equal to validates(:name, presence: true)
    
        Valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i  
    validates :email, presence: true, length: {maximum:255}, 
        format: { with: Valid_email_regex }, # Weakness of this regex is that it allows consecutive periods: foo@bar...com
        uniqueness: { case_sensitive: false } # Rails infers that :uniqueness is true with this option
        
    has_secure_password    
end