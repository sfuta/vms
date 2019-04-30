bash 'add_epel' do
  user 'root'
  code <<-EOC
    rpm -ivh http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/7/x86_64/e/epel-release-7-6.noarch.rpm
    sed -i -e "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/epel.repo
  EOC
  creates "/etc/yum.repos.d/epel.repo"
end

bash 'add_rpmforge' do
  user 'root'
  code <<-EOC
    rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
    sed -i -e "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/rpmforge.repo
  EOC
  creates "/etc/yum.repos.d/rpmforge.repo"
end

bash 'add_remi' do
  user 'root'
  code <<-EOC
    rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
    sed -i -e "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/remi.repo
  EOC
  creates "/etc/yum.repos.d/remi.repo"
end


bash 'add_mysql' do
  user 'root'
  code 'yum install -y http://repo.mysql.com/mysql57-community-release-el7-8.noarch.rpm'
  creates "/etc/yum.repos.d/mysql-community.repo"
end
