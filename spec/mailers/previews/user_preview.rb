# Preview all emails at http://localhost:3000/rails/mailers/user
class UserPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user/confirmation
  def confirmation
    UserMailer.confirmation(User.last.id, User.last.user_confirmations.last.id)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user/reset_password
  def reset_password
    UserMailer.confirmation(User.last.id, User.last.user_confirmations.last.id)
  end

end
