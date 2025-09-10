# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Clear existing data
Note.destroy_all
User.destroy_all

# Create Admin User
admin = User.create!(
  email: "admin@example.com",
  password: "password",
  role: :admin
)

# Create Regular User
user = User.create!(
  email: "user@example.com",
  password: "password",
  role: :user
)

# Create notes for Admin
3.times do |i|
  admin.notes.create!(
    title: "Admin Note #{i + 1}",
    content: "This is admin note number #{i + 1}."
  )
end

# Create notes for Regular User
5.times do |i|
  user.notes.create!(
    title: "User Note #{i + 1}",
    content: "This is user note number #{i + 1}."
  )
end

puts "Seed data created:"
puts "Admin: #{admin.email}, Notes: #{admin.notes.count}"
puts "User: #{user.email}, Notes: #{user.notes.count}"
