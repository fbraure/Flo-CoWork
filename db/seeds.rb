require 'faker'

p "CLEANING DATA"
# User.where.not(email: 'florent.braure@gmail.com').map(&:destroy) unless Rails.env.production? || Rails.env.staging?
User.all.map(&:destroy) unless Rails.env.production? || Rails.env.staging?
[Page].each { |model| model.destroy_all} unless Rails.env.production? || Rails.env.staging?
p "START SEEDING"

User.create(email: 'florent.braure@gmail.com',
            password: 'macpass',
            password_confirmation: 'macpass',
            admin: true,
            name: "Admin",
            phone: "0000000000",
            confirmed_at: DateTime.current,
            biography: "Gabrielle
                         Tu brûles mon esprit, ton amour étrangle ma vie
                         Et l'enfer
                         Ouais, devient comme un espoir car dans tes mains je meurs chaque soir
                         Je veux partager autre chose que l'amour dans ton lit
                         Et entendre la vie et ne plus m'essouffler sous tes cris
                         Oh fini, fini pour moi
                         Je ne veux plus voir mon image dans tes yeux, ouais
                         Dix ans de chaînes sans voir le jour, c'était ma peine forçat de l'amour
                         Et bonne chance à celui qui veut ma place
                         Dix ans de chaînes sans voir le jour, c'était ma peine forçat de l'amour
                         J'ai, moi, j'ai refusé
                         (Mourir d'amour enchaîné)
                         Oh, Gabrielle")
# jusqu'à 10 accepté
progresses = Request.progresses.values
nb_progesses = progresses.count
while User.accepteds.count < 10
  name = Faker::Name.first_name
  user = User.new(name: name,
                  email: "#{name.parameterize}@cowork.com",
                  password: "azerty",
                  password_confirmation: "azerty",
                  phone: "0123456789",
                  biography: Faker::Lorem.characters(number: 70),
                  ## avoid 1000 mails on seeding
                  confirmed_at: DateTime.current,
                  admin: false)
  if user.save
    progresses.take(rand(1..nb_progesses)).each do |progress|
      request = user.requests.create(progress: progress)
      user.update(confirmed_at: nil) if request.unconfirmed?
      user.update(confirmed_at: DateTime.current) if request.confirmed?
    end
  else
    p user.errors.full_messages
  end
end
p "#{User.count - 1} créés"
Page.create!(title: "Mentions Légales", content: "Est-ce vraiment légal ? ")
p "END SEEDING"

