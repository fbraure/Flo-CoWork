require 'faker'
ActionMailer::Base.perform_deliveries = false

p "CLEANING DATA"
# User.where.not(email: 'florent.braure@gmail.com').map(&:destroy) unless Rails.env.production? || Rails.env.staging?
User.all.map(&:destroy) unless Rails.env.production?
[Page].each { |model| model.destroy_all} unless Rails.env.production?
p "START SEEDING #{Rails.env.upcase}"

admin = User.new(email: 'florent.braure@gmail.com',
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
if admin.save
  admin.requests.create(progress: :confirmed)
else
  p user.errors.full_messages
  return
end
return
# jusqu'à 10 accepté
progresses = Request.progresses.keys.map(&:to_sym)
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
                  # confirmed_at: DateTime.current,
                  admin: false)
  if user.save
    progresses.take(rand(1..nb_progesses)).each do |progress|
      if progress == :confirmed
        # Le call back va créer la request
        user.update(confirmed_at: DateTime.current)
      # Je sors "unconfirmed de la liste => User.after_create"
      elsif progress != :confirmed
        request = user.requests.create(progress: progress)
      end
    end
  else
    p user.errors.full_messages
  end
end
p "#{User.count - 1} créés"
Page.create!(title: "Mentions Légales", content: "Est-ce vraiment légal ? ")
p "END SEEDING"

