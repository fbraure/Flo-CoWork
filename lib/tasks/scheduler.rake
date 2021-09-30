namespace :users do
  desc "This task is every night to ask to reconfirmed after 3 months"
  task :three_month_unconfirmation => :environment do
    User.confirmeds.map(&:ask_for_reconfimation)
  end
end