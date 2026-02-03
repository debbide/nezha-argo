#!/usr/bin/env bash

# renew.sh 鐢ㄤ簬鍦ㄧ嚎鍚屾鏈€鏂扮殑 backup.sh 鍜?restore.sh 鑴氭湰
# 濡傛槸 IPv6 only 鎴栬€呭ぇ闄嗘満鍣紝闇€瑕?Github 鍔犻€熺綉锛屽彲鑷鏌ユ壘鏀惧湪 GH_PROXY 澶?锛屽 https://mirror.ghproxy.com/ 锛岃兘涓嶇敤灏变笉鐢紝鍑忓皯鍥犲姞閫熺綉瀵艰嚧鐨勬晠闅溿€?
GH_PROXY=
WORK_DIR=
TEMP_DIR=

########

# 鑷畾涔夊瓧浣撳僵鑹诧紝read 鍑芥暟
warning() { echo -e "\033[31m\033[01m$*\033[0m"; }  # 绾㈣壊
error() { echo -e "\033[31m\033[01m$*\033[0m" && exit 1; } # 绾㈣壊
info() { echo -e "\033[32m\033[01m$*\033[0m"; }   # 缁胯壊
hint() { echo -e "\033[33m\033[01m$*\033[0m"; }   # 榛勮壊

trap "rm -rf $TEMP_DIR; echo -e '\n' ;exit" INT QUIT TERM EXIT

mkdir -p $TEMP_DIR

# 鍦ㄧ嚎鏇存柊 renew.sh锛宐ackup.sh 鍜?restore.sh 鏂囦欢
for i in {renew,backup,restore}; do
  if [ -s $WORK_DIR/$i.sh ]; then
    sed -n '1,/^########/p' $WORK_DIR/$i.sh > $TEMP_DIR/$i.sh
    wget -qO- ${GH_PROXY}https://raw.githubusercontent.com/debbide/nezha-argo/main/template/$i.sh | sed '1,/^########/d' >> $TEMP_DIR/$i.sh
    [ $(wc -l $TEMP_DIR/$i.sh | awk '{print $1}') -gt 20 ] && chmod +x $TEMP_DIR/$i.sh && mv -f $TEMP_DIR/$i.sh $WORK_DIR/ && info "\n Update $i.sh Successful. \n" || warning "\n Update $i.sh failed.\n" 
  fi
done

