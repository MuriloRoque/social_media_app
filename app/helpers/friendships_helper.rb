module FriendshipsHelper
  def friendship_button(friend)
    if friend.friend_requests.any?(current_user)
      simple_format('<p class= "request-sent">Request sent!</p>')
    elsif !current_user.friend?(friend)
      link_to image_tag("https://img.icons8.com/fluent/48/000000/add-user-group-man-man.png", class: 'friend-icon'), request_friendship_user_path(friend.id), method: :post
    else
      link_to image_tag("https://img.icons8.com/fluent/48/000000/filled-trash.png", class: 'friend-icon'), unfriend_user_path(friend), method: :delete
    end
  end
end