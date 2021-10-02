class AddContractToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :contract_accepted, :boolean, default: nil
    add_column :users, :contract_last_date, :datetime
  end
end
