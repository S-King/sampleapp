class Relationship < ActiveRecord::Base
=begin    belongs_to relationship creates the following methods
|                            Method	                          |           Purpose
|active_relationship.follower	                              |Returns the follower
|active_relationship.followed	                              |Returns the followed user
|user.active_relationships.create(followed_id: other_user.id) |Creates an active relationship associated with user
|user.active_relationships.create!(followed_id: other_user.id)|Creates an active relationship associated with user (exception on failure)
|user.active_relationships.build(followed_id: other_user.id)  |Returns a new Relationship object associated with user
=end
    belongs_to :follower, class_name: "User"
    belongs_to :followed, class_name: "User"
    
# Validations
    validates :follower_id, presence: true
    validates :followed_id, presence: true
    
end
