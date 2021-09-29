ActiveAdmin.register Page do

  permit_params :title, :content

  form do |f|
    f.inputs "Page" do
      f.input :title
      f.input :content, as: :ckeditor, label: false
    end
    f.button :submit
  end
end
