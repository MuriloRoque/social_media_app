class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, :class_name => "User"

  has_many :confirmed_friends, through: :friendships, source: :friend
  has_many :inverse_friends, through: :friendships, source: :user

  def duplicate_check
    return unless Friendship.where(user_id: friend_id,
                                   friend_id: user_id).exists? && Friendship.where(user_id: user_id,
                                                                                   friend_id: friend_id).exists?

    errors.add(:user_id, 'Already friends!')
  end
end
