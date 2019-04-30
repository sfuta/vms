# PHP Framework Package(Laravel)をインストール
# 
execute "install_laravel_pkg" do
  command <<-"EOS"
      cd /var/data/system/backend
      php composer install
      EOS
  user "root"
  creates "/var/data/system/backend/vendor"
  only_if "[ -e /var/data/system/backend/composer ];echo -n $?"
  action :run
end

# プロジェクトの環境変数を設定
# 
execute "set_project_env" do
  command <<-"EOS"
      cd /var/data/system/backend
      php composer run-script post-root-package-install
      php composer run-script post-create-project-cmd
      EOS
  user "root"
  only_if "[ -e /var/data/system/backend/composer ];echo -n $?"
  action :run
end
