namespace :users do
  desc "This task is launched every night to ask to reconfirmed email after 3 months"
  task :reconfirm_email_after_three_months => :environment do
    User.pendings.includes(:active_request).select{|u|u.active_request.created_at = Date.current}.map(&:unconfirm!)
  end
  desc "This task is launched every night to ask to reconfirmed contract after 1 months"
  task :reconfirm_contract_after_one_month => :environment do
    User.accepteds.where(:contract_last_date == Date.current - 1.month).map(&:unaccept!)
  end
end