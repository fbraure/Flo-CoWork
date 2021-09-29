ActiveAdmin.register User do

  permit_params :email, :encrypted_password, :password, :password_confirmation, :admin

  member_action :login_as, :method => :get do
    user = User.find(params[:id])
    sign_in(:user, user, bypass: true)
    flash[:alert] = "Vous êtes désormais connecté en tant que " + user.email
    redirect_to root_path
  end

  index do
    selectable_column
    column :id
    column :email
    toggle_bool_column :admin
    column :created_at
    column :updated_at
    column :login_as do |user|
      link_to user.email, login_as_admin_user_path(user), :target => '_blank'
    end
    actions
  end
  form do |f|
    tabs do
      tab 'User' do
        f.inputs do
          f.input :email
          f.input :password
          f.input :password_confirmation
          f.input :admin
          f.button :submit
        end
      end
    end
  end
  show do
    tabs do
      tab "Utilisateur" do
        attributes_table do
          row :email
          row :admin
        end
      end
    end
  end
  controller do
    def update
      return super if params[:user].nil?
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
      super
    end
  end
end
