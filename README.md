LTEPi Board Service
===

本サービスは、Raspberry Pi上で動作するLTEPiボードを動作させるためのサービスです。

このサービスでは、以下の機能を提供しています。

- Kyocera社製LTEモジュールの自動起動
- LTE接続の確立コマンド (`ltepi_connect`)
- LTE接続の切断コマンド (`ltepi_disconnect`)
- APN変更コマンド (`ltepi_set_apn`)
- ICCID取得コマンド (`ltepi_get_iccid`)

# LTEPiって何？
RaspberryPi B+やRaspberryPi 2 Model Bに取り付けが可能なLTE通信モジュールを搭載した基板です。

![LTEPi on RPiB+](http://lte4iot.com/wp-content/uploads/2015/05/LTEPi01.png)

# 対応ハードウェア
1. Raspberry Pi B+
1. Raspberry Pi2 Model B

# 対応OS
Raspbian 4.1以降

# インストール方法
Raspberry Piをインターネットに接続できる状態にして、以下のコマンドを入力してください。[ltepi](https://github.com/Robotma-com/ltepi)も同時にインストールされます。

```
$ VERSION=2.0.0
$ curl https://raw.githubusercontent.com/Robotma-com/ltepi-service/${VERSION}/install.sh | sudo bash
```

最新版を利用する場合は、以下のようにバージョンの指定を外すことができます。
```
$ curl https://raw.githubusercontent.com/Robotma-com/ltepi-service/master/install.sh | sudo bash
```

## インストール実行例
```
[INFO] Installing command lines to /opt/inn-farm/ltepi/bin...
[INFO] Installing config files to /opt/inn-farm/ltepi/bin...
[INFO] Installing LTEPi Python Library...
running install
running build
running build_py
creating build/lib.linux-armv6l-2.7
copying src/ltepi.py -> build/lib.linux-armv6l-2.7
running install_lib
running install_egg_info
Removing /usr/local/lib/python2.7/dist-packages/ltepi-0.9.5.egg-info
Writing /usr/local/lib/python2.7/dist-packages/ltepi-0.9.5.egg-info
writing list of installed files to '/opt/inn-farm//ltepi//bin/ltepi-files.txt'
[INFO] ltepi service has been installed
[ALERT] *** Please reboot the system! (enter 'sudo reboot') ***
```

# アンインストール方法
ホームディレクトリーに移りアンインストールのスクリプトを実施してください。
```
$ cd ~
$ sudo /opt/inn-farm/ltepi/bin/uninstall.sh
```

## アンインストール実行例
```
$ cd ~
$ sudo /opt/inn-farm/ltepi/bin/uninstall.sh 
Removed symlink /etc/systemd/system/multi-user.target.wants/ltepi.service.
[INFO] ltepi has been uninstalled
```

# 設定
## 自動インターネット接続設定
デフォルトでは、一度このサービスをインストールすると、起動時に常にインターネットへの接続を行います。
一方で、起動時に接続を行わないように設定することも可能です。

`/opt/inn-farm/ltepi/enrionment`をエディターで開き、`LTEPI_CONNECT_ON_BOOT=1`の1を0に変更すると、次回から起動時に接続しないようになります。


# モジュールリリース時の注意
1. [`install.sh`](install.sh)内の`VERSION=`にあるバージョンを修正してコミットする
1. 履歴を追記、修正してコミットする
1. （もし必要があれば）パッケージング
```
$ ./install.sh pack
```

## 開発用インストール動作確認
```
$ ./install pack
(scp to RPi then ssh)
$ mkdir tmp && cd tmp && tar zxf ~/ltepi-service-2.0.0.tgz
$ sudo SRC_DIR=$(pwd) DEBUG=1 ./install.sh
```

# 履歴
* 2.0.0
  - GitHub公開
  - Raspbian 4.1対応 (Raspbian 4.1より前のバージョンには対応していません)
  - リモートインストーラーを追加
  - アンインストーラーを追加
  - バージョンファイルをインストール時に生成するように変更
  - 以下のコマンドが追加されました。また、どの場所からでも呼び出すことが可能です
     - 接続コマンド ... `ltepi_connect`
     - 切断コマンド ... `ltepi_disconnect`
     - APN設定コマンド ... `ltepi_set_apn`
  - 以下のコマンドは名称が変わりました。また、どの場所からでも呼び出すことができるようになりました
     - `get_iccid` => `ltepi_get_iccid`
  - サービス内で利用するモデムON/OFF、GPIO解放内部コマンドを追加（これら内部コマンドを直接実行してはいけません）
  - 以下のコマンドはモジュール内部利用に変更しました。これらの内部コマンドを直接実行してはいけません。`sudo systemctl start ltepi`または`sudo systemctl stop ltepi`を代わりに利用してください。
     - `gpio_init`
     - `vbus_on`
     - `vbus_off`
     - `power_on`
     - `power_off`

* 1.0.0
  - 初版、lte4iot.comにて公開
