class UserPolicy < ApplicationPolicy
  def request_friend?
    # user cannot as friend to self. User has not yet already requested for friendship. User is not friend
    @record.id != @user.id && !@record.pending_friends.include?(@user) && !@record.requested_friends.include?(@user) && !@record.friends.include?(@user)
  end

  def accept_friend?
    @record.id != @user.id && @record.pending_friends.include?(@user)
  end
end
