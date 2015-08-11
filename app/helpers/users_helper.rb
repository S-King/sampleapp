module UsersHelper
    # Returns a Gravatar for the supplied user
    def gravatar_for(user)
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
        image_tag(gravatar_url, alt: user.name, class: "gravatar") # returns an image tag for the Gravatar with a gravatar CSS class and alt text equal to the user’s name
    end
end
