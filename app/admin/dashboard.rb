ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end
  end
  content title: "Stats" do
    columns do
      column do
        panel "NB DEMANDES EN COURS" do
          table_for Request.stats.each do
            column("Status") {|status, _| enum_translated_for(:request, :progresses, status)}
            column("Nb de demandes") { |_, nb| nb}
          end
        end
      end
    end
  end
end
