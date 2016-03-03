LTEPi Board Service
===

[![GitHub release](https://img.shields.io/github/release/Robotma-com/ltepi-service.svg)](https://github.com/Robotma-com/ltepi-service/releases/latest)
[![License BSD3](https://img.shields.io/github/license/Robotma-com/ltepi-service.svg)](http://opensource.org/licenses/BSD-3-Clause)

本サービスは、Raspberry Pi上で動作する[LTEPi](http://lte4iot.com/products/ltepi/)ボードを動作させるためのサービスです。

このサービスでは、以下の機能を提供しています。

- Kyocera社製LTEモジュールの自動起動
- LTE接続の確立コマンド (`ltepi_connect`)
- LTE接続の切断コマンド (`ltepi_disconnect`)
- APN変更コマンド (`ltepi_set_apn`)
- ICCID取得コマンド (`ltepi_get_iccid`)
- GPS位置取得コマンド (`ltepi_get_gps`)
- LTEモジュールをSIM優先モードに切り替えるコマンド(`ltepi_select_sim`) ... 手動で実行することはありません

また、以下のモジュールも同時にインストールされます。**常にインストールされます。**
- [ltepi](https://github.com/Robotma-com/ltepi) ... Pythonライブラリー

以下のモジュールは、インストールの可否を選択可能です。 **通常はインストールされます。**
- [CANDY RED](https://github.com/dbaba/candy-red) ... CANDY EGGクラウドサービスに接続可能なNode-REDベースのフローエディターです。Node.js v0.12またはv4.3が入っていない場合は、Node.js v0.12もインストールされます。すべてのインストールを終えるまでは、有線LAN環境で40分程度かかります。

# LTEPiって何？
正しくRaspberry Pi B+や正しくRaspberry Pi 2 Model Bに取り付けが可能なLTE通信モジュールを搭載した基板です。[Robotma.com](https://www.robotma.com/webshop/products/list.php?category_id=75)にてご購入いただけます。

![LTEPi on RPiB+](http://lte4iot.com/wp-content/uploads/2015/05/LTEPi01.png)

# 対応ハードウェア
1. Raspberry Pi B+
1. Raspberry Pi2 Model B

# 対応OS
Raspbian 4.1以降

# 準備するもの
インストールを行う前に以下のものを揃えておきましょう。

1. Raspberry Pi本体
1. Raspbianインストール済みのマイクロSDカード
1. [LTEPi](http://lte4iot.com/products/ltepi/)本体（あらかじめRaspberry Piに取り付けておいて下さい）
1. [LTEPi](http://lte4iot.com/products/ltepi/)付属のアンテナケーブルとアンテナ本体
1. au/KDDI SIMカード（回線契約が有効であるもの）
1. [LTEPi](http://lte4iot.com/products/ltepi/)付属のUSBケーブル
1. Raspberry Pi電源供給用USBケーブル
1. LANケーブル
1. インターネット・ブロードバンドルーター

# バージョンアップ方法
[インストール方法](#インストール方法)と同様です。インストール時に自動的にアンインストールが実行されます。

# インストール方法
最初にLANケーブルの一方をRaspberry Piに、もう一方をブロードバンドルーターに接続してインターネットに通信できる状態にしてください。
すでにRaspberry PiにてWi-Fiの設定を行い利用できている場合は、Wi-Fi経由で作業を行うことも可能です。

試しに以下のようなcURLコマンドを実行してみましょう。

```bash
$ curl -i -L -X HEAD http://www.robotma.com/
```

下記のように`HTTP/1.1 200 OK`と出ていれば問題ありません。
```bash
HTTP/1.1 200 OK
Date: Fri, 30 Oct 2015 04:43:43 GMT
Server: Apache
Last-Modified: Mon, 14 Sep 2015 07:08:39 GMT
ETag: "41ed5a-1947-bc184bc0"
Accept-Ranges: bytes
Content-Length: 6471
Content-Type: text/html

curl: (18) transfer closed with 6471 bytes remaining to read
root@binita:~#
```

それでは、GitHub上にあるスクリプトをダウンロードしてインストールします。

以下のコマンドを実行します（`git.io`もGitHubの管理するドメインの1つです）。

```bash
$ curl -L https://git.io/vgKU2 | sudo bash
```

[CANDY RED](https://github.com/dbaba/candy-red)を **インストールしない場合** は、以下のように`CANDY_RED=0`を指定します。
```bash
$ curl -L https://git.io/vgKU2 | sudo CANDY_RED=0 bash
```

また、特定のバージョンを利用する場合は、以下のようにバージョンを指定することができます。
```bash
$ VERSION=2.0.0 && \
  curl -L https://raw.githubusercontent.com/Robotma-com/ltepi-service/${VERSION}/install.sh | \
  sudo bash
```

実行すると以下のように表示されます。

    [INFO] Installing command lines to /opt/inn-farm/ltepi/bin...
    [INFO] Installing config files to /opt/inn-farm/ltepi/bin...
    [INFO] Installing LTEPi Python Library...
              :
              :
    [INFO] Installing CANDY RED...
              :
              :
    [INFO] ltepi service has been installed
    [ALERT] *** Please shutdown the system then restart! (enter 'sudo shutdown -h now' first) ***

## インストール後の注意
インストールした後は、以下のコマンドを実行してシャットダウンしましょう。

```bash
$ sudo shutdown -h
```

上記コマンドを実行後に一旦USBケーブルを外してください。これは、LTEモジュールの電源も切断させるために行うものです。

そして、付属のアンテナを2本ともモジュールに接続します。続いて、au/KDDIのSIMカードを差し込みます。
最後に、付属のUSBケーブルで[LTEPi](http://lte4iot.com/products/ltepi/)とRaspberry Piを接続します。

ここまでの作業を行ったら、電源を再び入れてみてください。起動後しばらくすると、[LTEPi](http://lte4iot.com/products/ltepi/)のLEDが４つ点灯します。これはLTEモジュールが起動していることを表しています。

もし圏外だったり、アンテナが接続されていなかったりした場合は、LTEモジュールは起動できません。LEDの表示も赤色とオレンジの2種類のみとなります。
以下にLTEモジュールが起動しない場合のトラブルシューティングをまとめていますので、ご確認ください。

### LTEモジュールが起動しないときは？(LEDが赤色とオレンジだけ点灯しているとき)

LTEモジュールが動作するためにはいくつか条件が必要となります。Raspberry Piが動作するだけでは十分ではありませんのでうまくいかないときは、以下の項目を確認して試してみてください。

1. ltepi-serviceのインストールは完了していますか？ もしかすると、ltepi-serviceをインストールしていない別のSDカードを使用しているかもしれません。ltepi-serviceがインストールされていない場合、LTEモジュールは自動的に起動することはありません。`systemctl status ltepi`を実施し、`(/lib/systemd/system/lte.service; enabled)`と表示されていることを確認しましょう。
1. ltepi-serviceのインストールに失敗していませんか？ `systemctl status ltepi`を確認した時、activeとでたにもかかわらず、再度`systemctl status ltepi`を実施すると止まっていたり、モデムが起動していなかったりする場合があります。その場合はインストールが正しくできていない可能性がありますので、再度インストールのコマンドを実施してみましょう。
1. [LTEPi](http://lte4iot.com/products/ltepi/)とRaspberry Piは、付属のUSBケーブルで正しく接続されていますか？ Raspberry Pi本体の電源用USBアダプターとと[LTEPi](http://lte4iot.com/products/ltepi/)のUSB通信用アダプターは近い位置にありますから、間違えないようにしましょう。
1. au/KDDIの電波の圏内ですか？ [こちら](http://www.au.kddi.com/mobile/area/?bid=we-we-sn-0004)のauのサイトから4G LTEのサービスエリアを確認し、サービスエリア圏内であることを確認しましょう。また、au/KDDIの4G LTE対応の携帯電話をお持ちであれば、4G LTEの電波が圏内であることを確認してみましょう。
1. [LTEPi](http://lte4iot.com/products/ltepi/)のアンテナは正しく接続されていますか？ LTEモジュールは、電源が十分供給されていてもアンテナが接続されていないと起動することができません。LTEモジュールに接続するアンテナケーブルとアンテナ本体が、外れることなく取り付けられていることを確認しましょう。
1. Raspberry Piに供給する機器側からは十分な電力が供給できていますか？ [LTEPi](http://lte4iot.com/products/ltepi/)が動作するためには、Raspberry Piに加えてより多くの電力が必要になります。もしかするとUSBバスパワーを供給する機器側のUSBポートは、電力が十分ではないかもしれません。もしうまく動作しない場合は、別のUSBポートにつなぎ変えたり、別のUSB電源用意したりしてお試しください。
1. Raspberry Piに電源供給するために使用しているUSBケーブルは正しく動作していますか？ USBケーブルの商品の種類や使用状態によっては、[LTEPi](http://lte4iot.com/products/ltepi/)が動作するために必要な電力をRaspberry Piに伝えられていない可能性もあります。他のUSBケーブルもお試しください。

## CANDY REDへのブラウザー接続
オプション指定をせずインストールを行うと、[CANDY RED](https://github.com/dbaba/candy-red)が有効になっていますので、ブラウザーから接続してみましょう。Raspberry Piがつながっている有線または無線LANと同じネットワークにあるコンピューターのブラウザーで以下のアドレスを入力してページを表示させてみてください。
```
http://raspberrypi.local:8100
```
もしRaspberry Piのホスト名を変更していた場合は、「ホスト名.local」を「raspberrypi.local」の代わりに指定します。名前で繋がらないときは、IPアドレスを指定しましょう。

# アンインストール方法
ホームディレクトリーに移りアンインストールのスクリプトを実施してください。
```bash
$ cd ~
$ sudo /opt/inn-farm/ltepi/bin/uninstall.sh
```
このコマンドでは、[CANDY RED](https://github.com/dbaba/candy-red)は削除されません。[CANDY RED](https://github.com/dbaba/candy-red)を削除する場合は、後述の「[CANDY REDのアンインストール](#candy-redのアンインストール)」をご覧ください。

実行すると以下のように表示されます。
```bash
$ cd ~
$ sudo /opt/inn-farm/ltepi/bin/uninstall.sh
Removed symlink /etc/systemd/system/multi-user.target.wants/ltepi.service.
[INFO] ltepi has been uninstalled
```

## CANDY REDのアンインストール
以下のコマンドを実行すると、[CANDY RED](https://github.com/dbaba/candy-red)を削除することができます。
```bash
$ sudo npm uninstall -g --unsafe-perm candy-red
```

# 設定
## CANDY EGG連携
ltepiサービスをインストールすると、Raspberry Pi上にNode-REDベースのフローエディターである[CANDY RED](https://github.com/dbaba/candy-red)もインストールされます。通常のNode-REDとしての機能のほか、CANDY EGGクラウドサービスと連携して手軽にクラウドとのやりとりを行うアプリケーションを作成することができます。

初回インストール時に[CANDY RED](https://github.com/dbaba/candy-red)をインストールしていない場合(`CANDY_RED=0`を指定してインストールした場合)は、以下の手順で追加することができます。

### CANDY REDアプリケーションのインストール
まず最初に、ltepiサービスを停止し、LANケーブルまたはWiFiでインターネットに接続します。これは、ダウンロードにかかる通信をLTEではなく有線・無線LANにて行うようにするためです。
```bash
$ sudo systemctl stop ltepi
```
続いて、Node.jsを入れ替えます。Raspbian 4.1以降ではNode-REDがプリインストールされていますのでNode.jsもすでに入っています。しかし、[CANDY RED](https://github.com/dbaba/candy-red)インストール時に追加するアドオンを用意するときに、プリインストールされたNode.jsでは解決できないエラーが発生してしまいます。これを避けるため、Node.jsを入れ替えるようにします。

Raspberry Pi Model B+をお使いの場合は、以下のコマンドを実行します。
```bash
$ sudo apt-get update -y
$ sudo apt-get upgrade -y
$ wget http://node-arm.herokuapp.com/node_archive_armhf.deb
$ sudo dpkg -i node_archive_armhf.deb
$ sudo apt-get install -y python-dev python-rpi.gpio bluez
```

Raspberry Pi2をお使いの場合は、以下のコマンドを実行します。
```bash
$ sudo apt-get update
$ sudo apt-get upgrade
$ curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -
$ sudo apt-get install -y python-dev python-rpi.gpio bluez nodejs
```

続いて[CANDY RED](https://github.com/dbaba/candy-red)をインストールしましょう。インストールには、30分ほどかかります。
```bash
$ sudo NODE_OPTS=--max-old-space-size=128 npm install -g --unsafe-perm candy-red
```

### CANDY REDの動作確認
それでは動作しているかを確認します。
```bash
$ sudo systemctl status candy-red
```

上記を実行して、以下のような結果が得られれば問題ありません。

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

なお、この時点で、端末を再起動したときには、自動的に[CANDY RED](https://github.com/dbaba/candy-red)が起動するようになります。

続いて、ltepiを再度起動しましょう。
```bash
$ sudo systemctl start ltepi
```

1〜2分ほどで、モデムが起動しインターネットに接続します。以下のコマンドを実行して接続状況を確認することができます。

```bash
$ ip route | grep default
```

以下のように`usb0`と出ていれば成功です。
```
default via 192.168.225.1 dev usb0  metric 205
```

## CANDY REDへのブラウザー接続
最後にブラウザーから接続してみましょう。Raspberry Piがつながっている有線または無線LANと同じネットワークにあるコンピューターのブラウザーで以下のアドレスを入力してページを表示させてみてください。
```
http://raspberrypi.local:8100
```
もしRaspberry Piのホスト名を変更していた場合は、「ホスト名.local」を「raspberrypi.local」の代わりに指定します。名前で繋がらないときは、IPアドレスを指定しましょう。

## 自動インターネット接続設定
デフォルトでは、一度このサービスをインストールすると、起動時に常にインターネットへの接続を行います。
一方で、起動時に接続を行わないように設定することも可能です。

`/opt/inn-farm/ltepi/environment`をエディターで開き、`LTEPI_CONNECT_ON_BOOT=1`の1を0に変更すると、次回から起動時に接続しないようになります。

なお、この設定で起動した場合にインターネットへ接続する場合は、以下のコマンドを実行します。
```bash
$ sudo ltepi_connect
```

## 対SDカード破損方法
ltepiサービスや[CANDY RED](https://github.com/dbaba/candy-red)を動作させる場合は、通常スワップが発生することはありません。
しかし、Raspberry Piを使っていくうちに、気がつくとより多くのメモリーを使うプログラムを長期に渡って実行させてしまっていることもあるかもしれません。
そのような場合、Raspberry Piに装着されたSDカードは突然の電源断に対して脆弱となります。SDカードの破損は、SDカード書き込み中の電源断によって起こりやすいためです。

このため、Raspberry Piが販売された当初からいくつかの方法が紹介されているようです。例えば下記のようなものです。

 * http://www.e-ark.jp/raspberryjamsession-02/
 * http://raspberrypi.stackexchange.com/a/8038

また、上記のほか、Web検索にて種々の方法が紹介されていますので、目的や用途に合った方法をお試しください。
なお、これらの紹介はあくまで情報提供であり、私たちの保証する方法ではありませんのでご注意ください。

# コマンド説明

## GPS取得コマンド

以下の書式でコマンドを実行します。タイムアウト秒を省略すると15秒として扱われます。15秒より小さい値を指定することはできません。

    ltepi_get_gps [タイムアウト秒]

アンテナが繋がっていれば15秒程度で取得可能ですが、最初は20~30秒を指定しないとエラーとなる可能性があります。エラーとなっても再度コマンドを実行し、成功するまで繰り返しても構いません。ただし、`Start LTEPi Service prior to running this command!`と出ている場合は、モデム自体が起動していないので、ltepi-service自体が正しく起動できているか確認しましょう。

結果のJSONには、`status`と`result`のプロパティが入ります。エラーの場合は、`message`が`result`の代わりに入ります。

`result`プロパティの内容は以下の通りです。

 * status ... 測位結果(string) OK:成功  FAIL:測位失敗
 * count ... 測位結果番号(int)
 * lat ... 緯度(float) 北緯(+)　南緯(-)
 * lon ... 経度(float)　東経(+)　西経(-)
 * alt ... 海抜高度(int)　単位：メートル
 * time ... 測位時刻(日本標準時間) (string) フォーマット ISO8601 YYYY-MM-DDThh:mm:ss.sTZD (eg 1997-07-16T19:20:30.45+09:00)
 * smaj ... 長軸誤差(int)　単位：メートル
 * smin ... 短軸誤差(int)　単位：メートル
 * vert ... 高度誤差(int)　単位：メートル
 * majaa ... 長軸・短軸傾き(int)　単位：度(degree)

# 管理者向け
## モジュールリリース時の注意
1. [`install.sh`](install.sh)内の`VERSION=`にあるバージョンを修正してコミットする
1. 履歴を追記、修正してコミットする
1. （もし必要があれば）パッケージング
```bash
$ ./install.sh pack
```

## 開発用インストール動作確認
```bash
$ ./install.sh pack
(scp to RPi then ssh)
$ VERSION=2.2.0 && mkdir tmp && cd tmp && tar zxf ~/ltepi-service-${VERSION}.tgz
$ time sudo SRC_DIR=$(pwd) DEBUG=1 ./install.sh
```

# 履歴
* 2.3.0
  - LTEモジュールをSIM優先モードに切り替えるコマンド`ltepi_select_sim`を追加
  - サービス起動時にLTEモジュールを自動的にSIM優先モードに切り替えるように修正
  - インストールされた状態でもインストールを成功できるように修正（この動作によってバージョンアップにも対応）

* 2.2.0
  - GPS位置取得コマンド`ltepi_get_gps`を追加

* 2.1.0
  - CANDY REDをデフォルトで追加インストールする機能を追加（`CANDY_RED=0`で抑止可能）
  - CANDY REDのバージョンアップに伴い追加インストール・アンインストール手順を変更
  - LTEPi動作時のトラブルシューティングを追記

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
  - 初版、[lte4iot.com](http://lte4iot.com)にて公開
