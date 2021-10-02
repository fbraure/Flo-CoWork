class UserDecorator < ApplicationDecorator
  delegate_all

  def full_name
    name.present? ? "#{name} - #{email}" : email
  end

  def active_created_at_txt
    active_request&.created_at&.strftime("%d/%m/%Y - %Hh:%M:%S")
  end

  def contract_date_txt
    contract_last_date&.strftime("%d/%m/%Y - %H:%M:%S")
  end

end
