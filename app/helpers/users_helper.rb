module UsersHelper
# gravatar_for
    
    # Returns a Gravatar for the supplied user
    def gravatar_for(user, options = {size: 80 }) # Gravatar_for will take options such as size:
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        size = options[:size]
        gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
        image_tag(gravatar_url, alt: user.name, class: "gravatar") # returns an image tag for the Gravatar with a gravatar CSS class and alt text equal to the user’s name
    end
end
