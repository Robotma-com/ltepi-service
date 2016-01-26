# ltepi-setup
LTEPiボードを利用するためのソフトウェアです。

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
$ VERSION=1.0.1
$ curl https://raw.githubusercontent.com/Robotma-com/ltepi-setup/${VERSION}/setup | sudo bash
```

最新版を利用する場合は、以下のURLによりバージョンの指定を外すことができます。　
```
$ curl https://raw.githubusercontent.com/Robotma-com/ltepi-setup/master/setup | sudo bash
```

# モジュールリリース時の注意
1. [`setup`](setup)内の`VERSION=`にあるバージョンを修正してコミットする
1. 履歴を追記、修正してコミットする
1. （もし必要があれば）パッケージング
```
$ ./install.sh pack
```

# 履歴
* 1.0.1
  - GitHub公開
  - リモートインストーラーを追加
  - アンインストーラーを追加
  - バージョンファイルをsetupから生成するように変更
  - 1.0.0と実行コードは同一となっており、特に違いはありません

* 1.0.0
  - 初版、lte4iot.comにて公開
