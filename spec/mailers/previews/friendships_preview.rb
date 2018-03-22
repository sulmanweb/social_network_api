# Preview all emails at http://localhost:3000/rails/mailers/friendships
class FriendshipsPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/friendships/requested
  def requested
    FriendshipsMailer.requested(User.first, User.last)
  end

  # Preview this email at http://localhost:3000/rails/mailers/friendships/accepted
  def accepted
    FriendshipsMailer.accepted(User.last, User.first)
  end

end
