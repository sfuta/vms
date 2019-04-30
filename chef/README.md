# laravelフレームワークアプリ開発用リポジトリ

## 概要
サーバーサイド含む開発環境を以下使用して構築
```
VirtualBox:「PC仮想化ソフト」
Vagrant:   「仮想環境構築ソフト」
Chef:      「サーバー設定ツール」
```

## 事前準備
1. VirtualBoxおよびVagrantをインストール  
※以下サイトの「VirtualBoxをインストールする」「Vagrantをインストールする」を実施  
http://techacademy.jp/magazine/6304

1. VagrantにChef連携のためのプラグインをインストール
  ```
  vagrant plugin install vagrant-omnibus
  ```

## 開発環境構築手順

1. terminalを起動し、開発用ディレクトリ(なければ作成してから)に移動  
 例)  
 `mkdir -p ~/workspace`  
 `cd ~/workspace`

1. 当リポジトリをcloneし、リポジトリのディレクリに移動  
1. Vagrant起動
  `vagrant up`  

1. hostsの設定(仮想環境のIPとドメインのマッピング)  
    * hosts設定ファイルを開く：`sudo vim /etc/hosts`
    * hosts設定ファイルに下記を追記  
    > 192.168.33.10 sandox.local.backend

## 補足等

### システムのVersion（変更したら都度更新しておくこと)

| カテゴリ   | バージョン   |
| ---------: | :----------- |
| OS         | CentOS 7.15  |
| DB         | MySQL 5.7.13 |
| Web Server | Apache 2.4.6 |
