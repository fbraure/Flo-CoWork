p "CLEANING DATA"
[User, Page].each { |model| model.destroy_all} unless Rails.env.production?
p "START SEEDING"
User.create!(email: 'florent.braure@gmail.com', password: 'macpass', password_confirmation: 'macpass', admin: true, name: "Admin", phone: "0000000000")
Page.create!(title: "Mentions Légales", content: "Est-ce vraiment légal ? ")
p "END SEEDING"

