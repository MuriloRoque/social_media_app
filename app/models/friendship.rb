class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  has_many :confirmed_friends, through: :friendships, source: :friend
  has_many :inverse_friends, through: :friendships, source: :user

  def destroy_friendship
    inverse = Friendship.find_by(user_id: friend, friend_id: user)
    destroy
    inverse.destroy
  end
end
