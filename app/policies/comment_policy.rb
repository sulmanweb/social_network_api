class CommentPolicy < ApplicationPolicy

  def update?
    @record.user == @user
  end

  def destroy?
    @record.user == @user
  end
end
