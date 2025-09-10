class AddDefaultToUsersActiveColumn < ActiveRecord::Migration[8.0]
  def change
    change_column_default :users, :active, from: nil, to: true
    change_column_null :users, :active, false, true
  end
end
