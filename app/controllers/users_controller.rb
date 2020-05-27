class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    @current_user = User.find(current_user.id)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
    @current_user = User.find(current_user.id)
  end

  def reject
    friendship = current_user.incoming_friendships.find_by(friend_id: current_user.id)
    friendship.destroy
    redirect_back(fallback_location: root_path)
  end

  def send_friendship
    friendship = current_user.friendships.build(friend_id: params[:id], confirmed: false)
    friendship.save
    redirect_back(fallback_location: root_path)
  end

  def accept
    friend = User.find(params[:id])
    current_user.confirm_friend(friend)
    redirect_back(fallback_location: root_path)
  end

  def cancel
    friendship = current_user.pending_friendships.find_by(friend_id: params[:id])
    friendship.destroy
    redirect_back(fallback_location: root_path)
  end

  def unfriend
    friend = current_user.confirmed_friendships.find_by(friend_id: params[:id])
    friend.destroy_friendship
    redirect_back(fallback_location: root_path)
  end
end
