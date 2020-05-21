class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
  end
  def send_friendship_request
    f = Friendship.where(user_id: params[:id], friend_id: current_user.id)
        if f.exist?
          f.update_all(confirmed:true)
          redirect_to users_path
          return
        end
        r = Friendship.where(user_id: current_user.id, friend_id: params[:id]).exists?
        if !r
        friend = Friendship.new(user_id: current_user.id, friend_id: params[:id],confirmed:false)
        friend.save
        else
          friend = Friendship.where(user_id: current_user.id, friend_id: params[:id]).select('id')
          Friendship.destroy(friend.ids)
        end
        redirect_to users_path
  end
end