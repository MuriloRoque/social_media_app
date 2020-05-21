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
    f = Friendship.where(user_id: params[:id], friend_id: current_user.id).select('id')
    Friendship.destroy(f.ids)
    redirect_to users_path
  end

  def send_req
    a = Friendship.where(user_id: current_user.id, friend_id: params[:id], confirmed: true)
    b = Friendship.where(user_id: params[:id], friend_id: current_user.id, confirmed: true)
    c = Friendship.where(user_id: params[:id], friend_id: current_user.id)
    if a.exists? || b.exists?
      Friendship.destroy(a.select('id').ids)
      Friendship.destroy(b.select('id').ids)
      redirect_to users_path
      return
    elsif c.exists?
      c.update_all(confirmed: true)
      redirect_to users_path
      return
    end
    f = Friendship.where(user_id: current_user.id, friend_id: params[:id]).exists?
    if !f
      friend_obj = Friendship.new(user_id: current_user.id, friend_id: params[:id], confirmed: false)
      friend_obj.save
    else
      friend_obj = Friendship.where(user_id: current_user.id, friend_id: params[:id]).select('id')
      Friendship.destroy(friend_obj.ids)
    end
    redirect_to users_path
  end
end
