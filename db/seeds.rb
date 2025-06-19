user = User.find_or_initialize_by(email: "admin@avion.com")
user.password = "password123"
user.password_confirmation = "password123"
user.admin = true
user.approved = true
user.save!
puts "Seeded admin: #{user.email}, Admin?: #{user.admin}, Approved?: #{user.approved}"
