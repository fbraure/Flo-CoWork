namespace :users
  desc "This task is every night to ask to reconfirmed after 3 months"
  task :three_month_unconfirmation => :environment do
    User.confirmeds.each(&:ask_for_reconfimation)
  end
end