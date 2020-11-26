# Proxy Switcher for Ubuntu
Ubuntuのターミナル内のProxy設定を一括で変更するシェルスクリプトです。

## 使い方
3, 4行目の`PROXY_HOST`と`PROXY_PORT`を設定することで使用できます。
> アカウント指定には対応できていません…

```shell
$ chmod +x proxy.sh
$ ./proxy.sh
…
…
…
1=ON
0=OFF
```

## 対応設定
```
apt
Terminal Common
	wget
	curl
git
```
