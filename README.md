# Proxy Switcher for Ubuntu
Ubuntuのターミナル内のProxy設定を一括で変更するシェルスクリプトです。

## 使い方
```
$ git clone https://github.com/nemuki/Proxy-Switcher-for-Ubuntu.git
$ cd Proxy-Switcher-for-Ubuntu
$ nano proxy.sh

--- proxy.sh
# 3, 4行目の`PROXY_HOST`と`PROXY_PORT`を設定することで使用できます。
PROXY_HOST="your proxy address"
PROXY_PORT="your proxy port"
---

$ chmod +x proxy.sh
$ source proxy.sh
…
…
…
ON
OFF
```

## 対応設定
```
apt
Terminal Common
  wget
  curl
git
```
