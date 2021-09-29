ActiveAdmin.register Request do
  actions :index

  permit_params :progress, :created_at, :active

  index do
    selectable_column
    column :id
    column :user do |request|
      link_to request.user.decorate.full_name, admin_user_path(request.user)
    end
    column :progress do |request|
      enum_translated_for(:request, :progresses, request.progress)
    end
    column :created_at
    actions
  end
end
