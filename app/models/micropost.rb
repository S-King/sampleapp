class Micropost < ActiveRecord::Base
  
=begin  
  The belongs_to/has_many relationship automatically creates the following methods:
|           Method             |                  Purpose
|micropost.user	               |Returns the User object associated with the micropost
|user.microposts	             |Returns a collection of the user’s microposts
|user.microposts.create(arg)	 |Creates a micropost associated with user
|user.microposts.create!(arg)	 |Creates a micropost associated with user (exception on failure)
|user.microposts.build(arg)	   |Returns a new Micropost object associated with user
|user.microposts.find_by(id: 1)|Finds the micropost with id 1 and user_id equal to user.id
=end
  belongs_to :user
  default_scope -> { order(created_at: :desc) } # Make a default order to retrieve things from the DB
  #Proc syntax takes in a block and returns a Proc which can be evaluated with a call method
  mount_uploader :picture, PictureUploader # Tells CarrierWave to associate an image with a model
  #Symbol represents attibute and class name represents generate uploader in picture_uploader.rb
  
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate :picture_size # Custom validation call for method corresponding to symbol name
  
  # Validate size of picture
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "Picture must be less than 5 MB") # Add a custom error to the errors collection of the object
    end
  end
  
end
