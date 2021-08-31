#!/bin/bash
#Set your proxy address & port
PROXY_HOST=""
PROXY_PORT=""

proxy_status=$(<./.proxy_status.txt)

case $proxy_status in
	# set
  "OFF" )
# apt
cat <<EOD | sudo tee /etc/apt/apt.conf.d/00proxy
Acquire::ftp::Proxy "http://$PROXY_HOST:$PROXY_PORT";
Acquire::http::Proxy "http://$PROXY_HOST:$PROXY_PORT";
Acquire::https::Proxy "http://$PROXY_HOST:$PROXY_PORT";
EOD

# Terminal common
export ftp_proxy="http://$PROXY_HOST:$PROXY_PORT"
export http_proxy="http://$PROXY_HOST:$PROXY_PORT"
export https_proxy="http://$PROXY_HOST:$PROXY_PORT"

# canonical-livepatch
# sudo canonical-livepatch config http-proxy=http://$PROXY_HOST:$PROXY_PORT
# sudo canonical-livepatch config https-proxy=http://$PROXY_HOST:$PROXY_PORT

# git
$(git config --global http.proxy http://$PROXY_HOST:$PROXY_PORT)
$(git config --global https.proxy http://$PROXY_HOST:$PROXY_PORT)

echo 'ON' > ./.proxy_status.txt
;;
	# unset
	"ON" )
# apt 
cat <<EOD | sudo tee /etc/apt/apt.conf.d/00proxy
# Acquire::ftp::Proxy "http://$PROXY_HOST:$PROXY_PORT";
# Acquire::http::Proxy "http://$PROXY_HOST:$PROXY_PORT";
# Acquire::https::Proxy "http://$PROXY_HOST:$PROXY_PORT";
EOD

# Terminal common
export -n ftp_proxy
export -n http_proxy
export -n https_proxy

# canonical-livepatch
# sudo canonical-livepatch config http-proxy=""
# sudo canonical-livepatch config https-proxy=""

# git
$(git config --global --unset http.proxy)
$(git config --global --unset https.proxy)

echo 'OFF' > ./.proxy_status.txt
;;

esac

proxy_status=$(<.proxy_status.txt)

echo $proxy_status
