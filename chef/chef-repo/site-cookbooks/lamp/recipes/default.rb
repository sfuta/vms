#
# Cookbook Name:: lamp
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#--------------------------------------
# install
#--------------------------------------

# Apacheをインストールする
#  sudo yum install -y httpd
package "httpd" do
    action :install
end

# MySQLをインストールする
#  sudo yum install -y mysql-community-server
package "mysql-community-server" do
    action :install
end

# PHPをインストールする
#  sudo yum install -y php
package "php" do
  action :install
  options "--enablerepo=remi-php56"
end

# PHPに関連するモジュールをインストールする
#  php-devel
#  php-pear
#  php-mbstring
#  php-pdo
#  php-mysql
#  php-tokenizer
#  php-openssl
#  php-xml
%w{php-devel php-pear php-mbstring php-pdo php-mysql php-tokenizer php-openssl php-xml}.each do |pkg|
  package pkg do
    action :install
    options "--enablerepo=remi-php56"
  end
end

#--------------------------------------
# service
#--------------------------------------

# Apacheの起動と自動起動の設定を行う
#  sudo service httpd start
#  sudo chkconfig on
service "httpd" do
  action [:start, :enable]
end

# MySQLの起動と自動起動の設定を行う
#  sudo service mysqld start
#  sudo chkconfig mysqld on
service 'mysqld' do
  action [:start, :enable]
end

#--------------------------------------
# directory
#--------------------------------------
# nothing

#--------------------------------------
# template
#--------------------------------------

# shellの言語設定を設置
#  sudo vi /etc/locale.conf
template "locale.conf" do
  path "/etc/locale.conf"
  source "locale.conf.erb"
  mode 0644
end

# vhost.confを設置する
#  sudo vi /etc/httpd/conf.d/vhost.conf
template "vhost.conf" do
  path "/etc/httpd/conf.d/vhost.conf"
  source "vhost.conf.erb"
  mode 0644
  notifies :restart, 'service[httpd]'
end

# my.cnf設置
#  sudo vi /etc/my.cnf
template "my.cnf" do
  path "/etc/my.cnf"
  source "my.cnf.erb"
  mode 0644
  notifies :restart, 'service[mysqld]'
end

# timezoneを設定するためのiniを設置する
#  sudo vi /etc/php.d/timezone.ini
template "timezone.ini" do
  path "/etc/php.d/timezone.ini"
  source "timezone.ini.erb"
  mode 0644
  notifies :restart, 'service[httpd]'
end


#--------------------------------------
# files
#--------------------------------------

# 起動スクリプトrc.local設定
# /etc/rc.local
cookbook_file "/etc/rc.d/rc.local" do
  source "rc.local"
  mode 00744
  owner 'root'
  group 'root'
end
