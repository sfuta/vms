# php mongodb 拡張ドライバをインストール
execute "install-php-mongodb" do
  command <<-"EOS"
    pecl install mongodb
    EOS
  user "root"
  not_if "pecl list | grep mongodb"
  action :run
end
# ini file設定
# /etc/php.d/20-mongodb.ini
cookbook_file "/etc/php.d/20-mongodb.ini" do
  source "20-mongodb.ini"
  mode 00644
  owner 'root'
  group 'root'
end

