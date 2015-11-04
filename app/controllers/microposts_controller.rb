class MicropostsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy]
    before_action :correct_user, only: [:destroy]
    
    def create
        @micropost = current_user.microposts.build(micropost_params)
            if @micropost.save # as long as micropost is valid
                flash[:success] = "Sucessfully Posted!"
                redirect_to root_url
            else
                @feed_items = [] #Set @feed_items to empty array if failed micropost submission
                render 'static_pages/home'
            end
    end
    
    def destroy
        @micropost.destroy
        flash[:success] = "Post Sucessfully Deleted"
        redirect_to request.referrer || root_url # will send back to requesting page or root if nil
    end

private

    def micropost_params
        params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
        @micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_url if @micropost.nil?
    end
end