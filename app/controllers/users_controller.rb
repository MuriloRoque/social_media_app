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
    friend_reject = Friendship.where(user_id: params[:id], friend_id: current_user.id).select('id')
    Friendship.destroy(friend_reject.ids)
    redirect_back(fallback_location: root_path)
  end

  def send_friendship
    Friendship.new(user_id: current_user.id, friend_id: params[:id], confirmed: false).save
    redirect_back(fallback_location: root_path)
  end

  def accept
    friend = Friendship.where(user_id: params[:id], friend_id: current_user.id)
    friend.update_all(confirmed: true)
    redirect_back(fallback_location: root_path)
  end

  def cancel
    friend = Friendship.where(user_id: current_user.id, friend_id: params[:id]).select('id')
    Friendship.destroy(friend.ids)
    redirect_back(fallback_location: root_path)
  end

  def unfriend
    current_friend = Friendship.where(user_id: current_user.id, friend_id: params[:id], confirmed: true)
    friend_current = Friendship.where(user_id: params[:id], friend_id: current_user.id, confirmed: true)
    Friendship.destroy(current_friend.select('id').ids)
    Friendship.destroy(friend_current.select('id').ids)
    redirect_back(fallback_location: root_path)
  end
end


