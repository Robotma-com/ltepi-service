LTEPi Board Service
===

[![GitHub release](https://img.shields.io/github/release/Robotma-com/ltepi-service.svg)](https://github.com/Robotma-com/ltepi-service/releases/latest)
[![License BSD3](https://img.shields.io/github/license/Robotma-com/ltepi-service.svg)](http://opensource.org/licenses/BSD-3-Clause)

本サービスは、Raspberry Pi上で動作するLTEPiボードを動作させるためのサービスです。

このサービスでは、以下の機能を提供しています。

- Kyocera社製LTEモジュールの自動起動
- LTE接続の確立コマンド (`ltepi_connect`)
- LTE接続の切断コマンド (`ltepi_disconnect`)
- APN変更コマンド (`ltepi_set_apn`)
- ICCID取得コマンド (`ltepi_get_iccid`)

# LTEPiって何？
RaspberryPi B+やRaspberryPi 2 Model Bに取り付けが可能なLTE通信モジュールを搭載した基板です。[Robotma.com](https://www.robotma.com/webshop/products/list.php?category_id=75)にてご購入いただけます。

![LTEPi on RPiB+](http://lte4iot.com/wp-content/uploads/2015/05/LTEPi01.png)

# 対応ハードウェア
1. Raspberry Pi B+
1. Raspberry Pi2 Model B

# 対応OS
Raspbian 4.1以降

# インストール方法
Raspberry Piをインターネットに接続できる状態にして、以下のコマンドを入力してください。[ltepi](https://github.com/Robotma-com/ltepi)も同時にインストールされます。

```
$ curl https://raw.githubusercontent.com/Robotma-com/ltepi-service/master/install.sh | sudo bash
```

特定のバージョンを利用する場合は、以下のようにバージョンを指定することができます。
```
$ VERSION=2.0.0
$ curl https://raw.githubusercontent.com/Robotma-com/ltepi-service/${VERSION}/install.sh | sudo bash
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

## インストール後の注意

インストールした後は、一度電源を切りましょう。そして、付属のアンテナを２本ともモジュールに接続します。続いて、au/KDDIのSIMカードを差し込みます。
最後に、付属のUSBケーブルでLTEPiとRaspberry Piを接続します。

ここまでの作業を行ったら、電源を再び入れてみてください。起動後しばらくすると、LTEPiのLEDが４つ点灯します。これはLTEモジュールが起動していることを表しています。

もし圏外だったり、アンテナが接続されていなかったりした場合は、LTEモジュールは起動できません。LEDの表示も赤色とオレンジの２種類のみとなります。

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
## CANDY EGG連携
Raspberry Pi上にNode-REDベースのフローエディターである[CANDY RED](https://github.com/dbaba/candy-red)をインストールすることができます。通常のNode-REDとしての機能のほか、CANDY EGGクラウドサービスと連携して手軽にクラウドとのやりとりを行うアプリケーションを作成することができます。

### CANDY REDアプリケーションのインストール
最初に、ltepiサービスを停止し、LANケーブルまたはWiFiでインターネットに接続します。これは、ダウンロードにかかる通信をLTEではなく有線・無線LANにて行うようにするためです。
```
$ sudo systemctl stop ltepi
```
続いて、Node.jsを入れ替えます。Raspbian 4.1以降ではNode-REDがプリインストールされていますのでNode.jsもすでに入っています。しかし、CANDY REDインストール時に追加するアドオンを用意するときに、プリインストールされたNode.jsでは解決できないエラーが発生してしまいます。これを避けるため、Node.jsを入れ替えるようにします。

Raspberry Pi Model B+をお使いの場合は、以下のコマンドを実行します。
```
$ sudo apt-get update -y
$ sudo apt-get upgrade -y
$ wget http://node-arm.herokuapp.com/node_archive_armhf.deb
$ sudo dpkg -i node_archive_armhf.deb
$ sudo apt-get install -y build-essential python-dev python-rpi.gpio
```

Raspberry Pi2をお使いの場合は、以下のコマンドを実行します。
```
$ sudo apt-get update
$ sudo apt-get upgrade
$ curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -
$ sudo apt-get install -y build-essential python-dev python-rpi.gpio nodejs
```

続いてBluetoothのドライバーをインストールします。これには40分ほどかかります。
```
$ BLUEZ_VER=5.37
$ sudo apt-get install -y libdbus-1-dev \
    libdbus-glib-1-dev libglib2.0-dev libical-dev \
    libreadline-dev libudev-dev libusb-dev make
$ wget https://www.kernel.org/pub/linux/bluetooth/bluez-${BLUEZ_VER}.tar.xz
$ tar xvf bluez-${BLUEZ_VER}.tar.xz
$ cd bluez-${BLUEZ_VER}
$ ./configure --disable-systemd
$ make
$ sudo make install
```

最後にCANDY REDをインストールしましょう。npmでのインストール（2行目）には、30分ほどかかります。
```
$ VERSION=2.0.0
$ sudo npm install -g --unsafe-perm https://github.com/dbaba/candy-red/archive/${VERSION}.tar.gz
$ sudo NODE_OPTS=--max-old-space-size=128 $(npm root -g)/candy-red/install.sh
```

上記3行目のコマンドを実行すると、以下のようなエラーメッセージが出ますが、無視してください。
```
npm ERR! invalid: node-pre-gyp@0.6.4 /usr/local/lib/node_modules/candy-red/node_modules/noble/node_modules/bluetooth-hci-socket/node_modules/usb/node_modules/node-pre-gyp
Created symlink from /etc/systemd/system/multi-user.target.wants/candy-red.service to /lib/systemd/system/candy-red.service.
pi: candy-red service has been installed.
```

それでは動作しているかを確認します。
```
$ sudo systemctl status candy-red
```

上記を実行して、以下のような結果が得られれば問題ありません。
```
● candy-red.service - CANDY RED Gateway Service, version:
   Loaded: loaded (/lib/systemd/system/candy-red.service; enabled)
   Active: active (running) since Wed 2016-01-27 02:11:31 UTC; 594ms ago
 Main PID: 3612 (bash)
   CGroup: /system.slice/candy-red.service
           ├─3612 bash /usr/local/lib/node_modules/candy-red/services/start_systemd.sh
           └─3618 node --max-old-space-size=128 /usr/local/lib/node_modules/candy-red/dist/index.j...

Jan 27 02:11:31 my-ltepi systemd[1]: Starting CANDY RED Gateway Service, version:...
Jan 27 02:11:31 my-ltepi systemd[1]: Started CANDY RED Gateway Service, version:.
Jan 27 02:11:31 my-ltepi start_systemd.sh[3612]: logger: Activating Bluetooth...
Jan 27 02:11:31 my-ltepi start_systemd.sh[3612]: Can't get device info: No such device
Jan 27 02:11:31 my-ltepi start_systemd.sh[3612]: logger: Starting candy-red...
```

なお、この時点で、端末を再起動したときには、自動的にCANDY REDが起動するようになります。

続いて、ltepiを再度起動しましょう。
```
$ sudo systemctl start ltepi
```

1〜2分ほどで、モデムが起動しインターネットに接続します。以下のコマンドを実行して接続状況を確認することができます。

```
$ ip route | grep default
```

以下のように`usb0`と出ていれば成功です。
```
default via 192.168.225.1 dev usb0  metric 205
```

それでは、ブラウザーからCANDY REDに接続してみましょう。Raspberry Piがつながっている有線または無線LANと同じネットワークにあるコンピューターのブラウザーで以下のアドレスを入力してページを表示させてみてください。
```
http://raspberry.local:8100
```
もしRaspberry Piのホスト名を変更していた場合は、「ホスト名.local」を「raspberry.local」の代わりに指定します。名前で繋がらないときは、IPアドレスを指定しましょう。

## 自動インターネット接続設定
デフォルトでは、一度このサービスをインストールすると、起動時に常にインターネットへの接続を行います。
一方で、起動時に接続を行わないように設定することも可能です。

`/opt/inn-farm/ltepi/enrionment`をエディターで開き、`LTEPI_CONNECT_ON_BOOT=1`の1を0に変更すると、次回から起動時に接続しないようになります。

なお、この設定で起動した場合にインターネットへ接続する場合は、以下のコマンドを実行します。
```
$ ltepi_connect
```

# [開発向け]モジュールリリース時の注意
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
