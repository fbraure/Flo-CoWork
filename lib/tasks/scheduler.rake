namespace :users do
  desc "This task is every night to ask to reconfirmed email after 3 months"
  task :reconfirm_after_three_month => :environment do
    User.confirmeds.map(&:ask_for_reconfimation)
  end
end