class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'

  def mutual_friends(current_user, user)
    count = 0
    user.friendships.where(confirmed: true).each do |friendship|
      count += 1 if current_user.friends?(friendship.friend_id)
    end
    user.inverse_friendships.where(confirmed: true).each do |friendship|
      count += 1 if current_user.friends?(friendship.user_id)
    end
    count
  end

  def friends?(id)
    Friendship.where(user_id: self.id,friend_id: id,confirmed: true).exists? || Friendship.where(friend_id: self.id,user_id: id,confirmed: true).exists?
  end

end
