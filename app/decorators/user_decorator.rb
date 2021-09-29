class UserDecorator < ApplicationDecorator
  delegate_all

  def full_name
    name.present? ? "#{name} - #{email}" : email
  end

end
