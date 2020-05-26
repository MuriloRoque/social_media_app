module UsersHelper
  def request_friendship(user2)
    if current_user.friends.include?(user2)
      1
    elsif current_user.incoming_friends.include?(user2)
      2
    elsif current_user.pending_friends.include?(user2)
      3
    else
      4
    end
  end
end
