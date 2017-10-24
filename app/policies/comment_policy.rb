class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def new_comment_for_post?
    new?
  end

  def update?
    return true if user.present? && user == comment.user
  end

  def destroy?
    return true if user.present? && user == comment.user
  end

  private
    def comment
      record
    end
end
