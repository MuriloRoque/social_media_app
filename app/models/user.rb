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

  has_many :confirmed_friendships, -> { where(confirmed: true) }, class_name: 'Friendship'
  has_many :friends, through: :confirmed_friendships

  has_many :pending_friendships, -> { where confirmed: false }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :pending_friends, through: :pending_friendships, source: :friend

  has_many :incoming_friendships, -> { where confirmed: false }, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :incoming_friends, through: :incoming_friendships, source: :user

  def friends?(id)
    Friendship.where(user_id: self.id, friend_id: id, confirmed: true).exists? ||
      Friendship.where(friend_id: self.id, user_id: id, confirmed: true).exists?
  end

  def confirm_friend(user)
    friendship = incoming_friendships.find_by(user_id: user)
    friendship.update(confirmed: true)
    Friendship.create(user: friendship.friend, friend: friendship.user, confirmed: true)
  end
end
