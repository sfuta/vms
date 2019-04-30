#
# Cookbook Name:: lamp
# Recipe:: mysql_config
#
# テーブル作成等、DB作成のためのrecipe
# ※mysqld restartしていること
# 

#--------------------------------------
# execute
#--------------------------------------

# MySQLのルートユーザーのパスワードを変更するためのコマンドを実行する
execute "mysql-change-root-password" do
  command <<-"EOS"
          systemctl set-environment MYSQLD_OPTS='--skip-grant-tables' 
          systemctl restart mysqld 
          mysql -e "
                    UPDATE mysql.user SET 
                      authentication_string = PASSWORD('#{node['mysql_config']['rootpass']}'), password_expired = 'N' 
                    WHERE User = 'root' AND Host = 'localhost';
                    FLUSH PRIVILEGES;
                  " &&
          systemctl unset-environment MYSQLD_OPTS 
          systemctl restart mysqld
          EOS
  not_if "/usr/bin/mysql -u root -p#{node['mysql_config']['rootpass']}"
  user "root"
  action :nothing
end

# MySQLにユーザー作成のSQLを実行するコマンドを用意する
#  /usr/bin/mysql -u root --password="パスワード" < /tmp/mysql-db-init.sql
execute "mysql-db-init" do
  command "mysql -u root -p#{node['mysql_config']['rootpass']} < /tmp/mysql-db-init.sql"
  user "root"
  action :nothing
end

#--------------------------------------
# template
#--------------------------------------

# MySQLのDB初期設定を実行
# ユーザーの作成およびDBのインポート
template "/tmp/mysql-db-init.sql" do
    owner "root"
    group "root"
    mode "0600"
    variables(
        :user     => node['mysql_config']['user'],
        :password => node['mysql_config']['pass']
#        :database => node['mysql_config']['database']
    )
    notifies :run, "execute[mysql-change-root-password]", :immediately
    notifies :run, "execute[mysql-db-init]", :immediately
end
