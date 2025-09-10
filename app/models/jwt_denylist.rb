# app/models/jwt_denylist.rb
class JwtDenylist < ApplicationRecord
  self.table_name = "jwt_denylist"  # matches schema

  include Devise::JWT::RevocationStrategies::Denylist

  validates :jti, presence: true
end
