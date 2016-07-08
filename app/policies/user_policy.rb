class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def new?
    index?
  end

  def create?
    index?
  end

  def show?
    index?
  end

  def edit?
    index?
  end

  def update?
    index?
  end

  def reset_password?
    index?
  end

  def activate?
    index?
  end

  def deactivate?
    index?
  end

  def destroy?
    index?
  end
end
