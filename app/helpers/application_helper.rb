module ApplicationHelper
  def svg_tag(name)
    file_path = Rails.root + "/app/assets/images/" + name + ".svg"
    if File.exists?(file_path)
      File.read(file_path).html_safe
    else
      '(not found)'
    end
  end
end
