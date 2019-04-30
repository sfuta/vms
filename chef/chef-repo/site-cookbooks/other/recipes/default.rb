# firewalldを停止する
# ※開発用のため
service "firewalld" do
  action [:stop, :disable]
end

# vimrc設定
#  sudo vi /etc/vimrc
cookbook_file "/etc/vimrc" do
  source "vimrc"
  owner 'root'
  group 'root'
  mode 0644
end

# vimのカラースキーム設定
# /usr/share/vim/vim74/colors/
cookbook_file "/usr/share/vim/vim74/colors/hybrid.vim" do
  source "hybrid.vim"
  mode 00644
  owner 'root'
  group 'root'
end
