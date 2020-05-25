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
    current_friend = Friendship.where(user_id: current_user.id, friend_id: params[:id], confirmed: true)
    friend_current = Friendship.where(user_id: params[:id], friend_id: current_user.id, confirmed: true)
    friend_accept = Friendship.where(user_id: params[:id], friend_id: current_user.id)
    if current_friend.exists? || friend_current.exists?
      send_friendship_1(current_friend, friend_current)
      redirect_back(fallback_location: root_path)
      return
    elsif friend_accept.exists?
      friend_accept.update_all(confirmed: true)
      redirect_back(fallback_location: root_path)
      return
    end
    friend_delete = Friendship.where(user_id: current_user.id, friend_id: params[:id]).exists?
    if !friend_delete
      Friendship.new(user_id: current_user.id, friend_id: params[:id], confirmed: false).save
    else
      friend_sent = Friendship.where(user_id: current_user.id, friend_id: params[:id]).select('id')
      Friendship.destroy(friend_sent.ids)
    end
    redirect_back(fallback_location: root_path)
  end
end

private

def send_friendship_1(current_friend, friend_current)
  Friendship.destroy(current_friend.select('id').ids)
  Friendship.destroy(friend_current.select('id').ids)
end
