ActiveAdmin.register User do
  actions :index, :show, :edit, :destroy, :login_as

  permit_params :email, :encrypted_password, :password, :password_confirmation, :admin,
    :name, :phone, :confirmed_at, :biography, :contract_accepted, :contract_last_date,
    requests_attributes: [:id, :progress, :active, :_destroy]

  scope :all, :default => true
  scope :unconfirmeds, association_method: :unconfirmeds
  scope :accepteds, association_method: :accepteds
  scope :confirmeds, association_method: :confirmeds
  scope :expireds, association_method: :confirmeds
  scope :pendings, association_method: :pendings

  member_action :unconfirm, :method => :post do
    user = User.find(params[:id])
    user.unconfirm!
    redirect_to admin_users_path
  end

  member_action :unaccept, :method => :post do
    user = User.find(params[:id])
    user.unaccept!
    redirect_to admin_users_path
  end

  member_action :login_as, :method => :get do
    user = User.find(params[:id])
    sign_in(:user, user, bypass: true)
    flash[:alert] = "Vous êtes désormais connecté en tant que " + user.email
    redirect_to root_path
  end

  index do
    selectable_column
    column :id
    column :name
    column :login_as do |user|
      link_to user.email, login_as_admin_user_path(user), target: '_blank'
    end
    column "Statut Actif" do |user|
      enum_translated_for(:request, :progresses, user.active_request&.progress) if user.active_request.present?
    end
    column "Date Statut" do |user|
      user.decorate.active_created_at_txt
    end
    column :unconfirm do |user|
      link_to "Unconfirm", unconfirm_admin_user_path(user), method: :post, target: '_blank' if user.confirmed?
    end
    column "Position" do |user|
      user.get_pending_position if user.pending?
    end
    toggle_bool_column :contract_accepted
    column :contract_last_date do |user|
      user.decorate.contract_date_txt
    end
    column :unaccept do |user|
      link_to "Unaccept", unaccept_admin_user_path(user), method: :post, :target => '_blank' if user.accepted? && user.contract_accepted?
    end
    column :phone
    column :biography do |user|
      user.biography.present?
    end
    toggle_bool_column :admin
    column :created_at
    column :updated_at
    actions
  end
  form do |f|
    tabs do
      tab 'Freelancers' do
        f.inputs do
          f.input :email
          f.input :password
          f.input :password_confirmation
          f.input :name
          f.input :phone
          f.input :confirmed_at, as: :datepicker
          f.input :contract_accepted
          f.input :contract_last_date, as: :datepicker
          f.input :biography, as: :ckeditor
          f.input :admin
          f.button :submit
        end
      end
      tab 'Demandes' do
        f.inputs do
          f.has_many :requests, for: [:requests, f.object.requests.order_by_created_at_asc], allow_destroy: true do |r|
            r.input :progress, collection:  enum_collection_translated_for(:request, :progresses)
            r.input :created_at, as: :datepicker, input_html: { disabled: true }
            r.input :active
          end
          f.submit
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
