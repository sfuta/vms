# yum_repoファイルを設定
cookbook_file "/etc/yum.repos.d/mongodb-org-3.2.repo" do
  source "mongodb-org-3.2.repo"
  owner 'root'
  group 'root'
  mode 0644
end
# nosql(mongodb)をインストール
#  sudo yum install -y mongodb-org
package "mongodb-org" do
  action :install
end

# nosql(mongodb)対応用にfile open可能数設定ファイル追加
cookbook_file "/etc/security/limits.d/99-mongodb-nproc.conf" do
  source "99-mongodb-nproc.conf" 
  owner 'root'
  group 'root'
  mode 0644
end

# nosql(mongodb)起動時の設定ファイル追加
cookbook_file "/etc/sysconfig/mongod" do
  source "mongod.sysconfig" 
  owner 'root'
  group 'root'
  mode 0644
end

# mongo shellの起動時読み込みファイル追加
cookbook_file "/etc/mongorc.js" do
  source "mongorc.js" 
  owner 'root'
  group 'root'
  mode 0644
end

# nosql(mongodb)を開始可能にする
service "mongod" do
  action [:enable]
end

# mongosを開始する
execute "start-mongos" do
  command <<-"EOS"
            /usr/bin/mongos -f /etc/mongos.conf &
          EOS
  user "root"
  action :nothing
end

# config serverが名前指定できるよう、host名を設定
execute "add-hosts" do
  command <<-"EOS"
            echo '#add mongo-config-server host' >> /etc/hosts
            echo '#{node['options']['host']}' >> /etc/hosts
          EOS
  user "root"
  not_if {node['options']['hosts'].nil?}
  not_if "grep '#add mongo-config-server host'"
  action :nothing
end

# nosql(mongodb)の設定ファイル配置
case node['options']['confType']
# config server
when 'config'
  cookbook_file "/etc/mongod.conf" do
    source "mongodc.conf" 
    owner 'root'
    group 'root'
    mode 0644
    notifies :restart, 'service[mongod]', :immediately
    notifies :run, 'execute[add-hosts]'
  end
# sharding router(mongos)
when 'mongos'
  cookbook_file "/etc/mongos.conf" do
    source "mongos.conf" 
    owner 'root'
    group 'root'
    mode 0644
    notifies :run, 'execute[start-mongos]', :immediately
  end
# shard(mongod)
when 'mongod'
  template "/etc/mongod.conf" do
    source "mongod.conf.erb"
    owner "root"
    group "root"
    mode "0644"
    variables(
      :rsName => node['options']['rsName']
    )
    notifies :restart, 'service[mongod]', :immediately
  end
end
