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
  has_many :inverse_friendships, -> { where confirmed: false }, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :friend_requests, through: :inverse_friendships
  has_many :pending_friendships, -> { where confirmed: false }, class_name: "Friendship", foreign_key: "user_id"
  has_many :pending_friends, through: :pending_friendships, source: :friend
  has_many :confirmed_friendships, -> { where confirmed: true }, class_name: 'Friendship'
  has_many :friends, through: :confirmed_friendships

  def mutual_friends(current_user, user)
    count = []
    user.friendships.where(confirmed: true).each do |friendship|
      count << User.find(friendship.friend_id).name if current_user.friends?(friendship.friend_id)
    end
    user.inverse_friendships.where(confirmed: true).each do |friendship|
      count << User.find(friendship.user_id).name if current_user.friends?(friendship.user_id)
    end
    count
  end

  def friends?(id)
    Friendship.where(user_id: self.id, friend_id: id, confirmed: true).exists? ||
      Friendship.where(friend_id: self.id, user_id: id, confirmed: true).exists?
  end

  def friends_and_own_posts
    Post.where(user: (self.friends + self))
  end
end
