class User < ApplicationRecord
  has_many :notes, dependent: :destroy
  has_many :activity_logs, dependent: :destroy

  devise(
    :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable,
    :jwt_authenticatable,
    jwt_revocation_strategy: JwtDenylist
  )

  enum :role, { user: 0, admin: 1 }

  after_initialize :set_default_role, if: :new_record?

  # scope to fetch only active users
  scope :active, -> { where(active: true) }

  def deactivate!
    update(active: false)
  end

  # ✅ Prevent inactive users from logging in
  def active_for_authentication?
    super && active?
  end

  # ✅ Custom message when inactive
  def inactive_message
    active? ? super : :inactive_account
  end

  private

  def set_default_role
    self.role ||= :user
  end
end
