#!/bin/bash
#Set your proxy address & port
PROXY_HOST=""
PROXY_PORT=""

function usage() {
cat <<_EOT_
Usage:
	$0 [-s status] arg1 ...

Description:
	Your env proxy switch script.

Options:
	-s	return current status.

_EOT_
exit 1
}

if [ "$OPTIND" = 1 ]; then
  while getopts abf:h OPT
  do
    case $OPT in
      s)
        FLAG_A="on"
        echo "FLAG_A is $FLAG_A"            # for debug
        ;;
      h)
        echo "h option. display help"       # for debug
        usage
        ;;
      \?)
        echo "Try to enter the h option." 1>&2
        ;;
    esac
  done
else
  echo "No installed getopts-command." 1>&2
  exit 1
fi

proxy_status=$(<./.proxy_status.txt)

case $proxy_status in
	# set
	"0" ) 
# apt
cat <<EOD | sudo tee /etc/apt/apt.conf.d/00proxy
Acquire::ftp::Proxy "http://$PROXY_HOST:$PROXY_PORT";
Acquire::http::Proxy "http://$PROXY_HOST:$PROXY_PORT";
Acquire::https::Proxy "http://$PROXY_HOST:$PROXY_PORT";
EOD

# Terminal common
cat <<EOD | sudo tee ~/.bashrc
export ftp_proxy="http://$PROXY_HOST:$PROXY_PORT"
export http_proxy="http://$PROXY_HOST:$PROXY_PORT"
export https_proxy="http://$PROXY_HOST:$PROXY_PORT"
EOD

# canonical-livepatch
#$(sudo canonical-livepatch config http-proxy=http://$PROXY_HOST:$PROXY_PORT)
#$(sudo canonical-livepatch config https-proxy=http://$PROXY_HOST:$PROXY_PORT)

# git
$(git config --global http.proxy http://$PROXY_HOST:$PROXY_PORT)
$(git config --global https.proxy http://$PROXY_HOST:$PROXY_PORT)

echo '1' > ./.proxy_status.txt
;;
	# unset
	"1" )
# apt 
cat <<EOD | sudo tee /etc/apt/apt.conf.d/00proxy
# Acquire::ftp::Proxy "http://$PROXY_HOST:$PROXY_PORT";
# Acquire::http::Proxy "http://$PROXY_HOST:$PROXY_PORT";
# Acquire::https::Proxy "http://$PROXY_HOST:$PROXY_PORT";
EOD

# Terminal common
cat <<EOD | sudo tee ~/.bashrc
# export ftp_proxy="http://$PROXY_HOST:$PROXY_PORT"
# export http_proxy="http://$PROXY_HOST:$PROXY_PORT"
# export https_proxy="http://$PROXY_HOST:$PROXY_PORT"
EOD

# canonical-livepatch
#$(sudo canonical-livepatch config http-proxy="")
#$(sudo canonical-livepatch config https-proxy="")

# git
$(git config --global --unset http.proxy)
$(git config --global --unset https.proxy)

echo '0' > ./.proxy_status.txt
;;

esac

proxy_status=$(<.proxy_status.txt)

echo $proxy_status

