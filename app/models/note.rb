class Note < ApplicationRecord
  belongs_to :user
  after_create  { |note| ActivityLog.create(user: note.user, action: "created", record_type: "Note", record_id: note.id) }
  after_update  { |note| ActivityLog.create(user: note.user, action: "updated", record_type: "Note", record_id: note.id) }
  after_destroy { |note| ActivityLog.create(user: note.user, action: "deleted", record_type: "Note", record_id: note.id) }
end
