#!/usr/bin/env bash

# restore.sh 浼犲弬 a 鑷姩杩樺師 README.md 璁板綍鐨勬枃浠讹紝褰撴湰鍦颁笌杩滅▼璁板綍鏂囦欢涓€鏍锋椂涓嶈繕鍘燂紱 浼犲弬 f 涓嶇鏈湴璁板綍鏂囦欢锛屽己鍒惰繕鍘熸垚澶囦唤搴撻噷 README.md 璁板綍鐨勬枃浠讹紱 浼犲弬 dashboard-***.tar.gz 杩樺師鎴愬浠藉簱閲岀殑璇ユ枃浠讹紱涓嶅甫鍙傛暟鍒欒姹傞€夋嫨澶囦唤搴撻噷鐨勬枃浠跺悕

GH_PROXY=
GH_PAT=
GH_BACKUP_USER=
GH_REPO=
SYSTEM=
WORK_DIR=
TEMP_DIR=/tmp/restore_temp
NO_ACTION_FLAG=/tmp/flag
IS_DOCKER=

########

# version: 2024.04.02

trap "rm -rf $TEMP_DIR; echo -e '\n' ;exit" INT QUIT TERM EXIT

mkdir -p $TEMP_DIR

warning() { echo -e "\033[31m\033[01m$*\033[0m"; }  # 绾㈣壊
error() { echo -e "\033[31m\033[01m$*\033[0m" && exit 1; } # 绾㈣壊
info() { echo -e "\033[32m\033[01m$*\033[0m"; }   # 缁胯壊
hint() { echo -e "\033[33m\033[01m$*\033[0m"; }   # 榛勮壊

cmd_systemctl() {
  local ENABLE_DISABLE=$1
  if [ "$ENABLE_DISABLE" = 'enable' ]; then
    if [ "$SYSTEM" = 'Alpine' ]; then
      local TRY=5
      until [ $(systemctl is-active nezha-dashboard) = 'active' ]; do
        systemctl stop nezha-dashboard; sleep 1
        systemctl start nezha-dashboard
        ((TRY--))
        [ "$TRY" = 0 ] && break
      done
      cat > /etc/local.d/nezha-dashboard.start << ABC
#!/usr/bin/env bash

systemctl start nezha-dashboard
ABC
      chmod +x /etc/local.d/nezha-dashboard.start
      rc-update add local >/dev/null 2>&1
    else
      systemctl enable --now nezha-dashboard
    fi

  elif [ "$ENABLE_DISABLE" = 'disable' ]; then
    if [ "$SYSTEM" = 'Alpine' ]; then
      systemctl stop nezha-dashboard
      rm -f /etc/local.d/nezha-dashboard.start
    else
      systemctl disable --now nezha-dashboard
    fi
  fi
}

# 鍦ㄦ湰鍦版湁涓嶅浠芥爣蹇楁枃浠舵椂锛屼笉鎵ц澶囦唤鎿嶄綔锛岀瓑寰?0鍒嗛挓銆傝Е鍙戣鏍囧織鍦烘櫙锛?. README.md 鏂囦欢鍐呭鍖呭惈鍏抽敭璇?backup锛?. backup.sh 鑴氭湰琚墜鍔ㄦ墽琛屽畬鎴愬悗淇濇寔 9 鍒嗛挓銆?if [ -e $NO_ACTION_FLAG* ]; then
  FLAG_STATUS=$(ls $NO_ACTION_FLAG*)
  WAIT_MINUTE=9
  if [ "${FLAG_STATUS: -1}" != "$WAIT_MINUTE" ]; then
    mv -f $FLAG_STATUS $NO_ACTION_FLAG$((${FLAG_STATUS: -1} + 1))
    error "\n The script is not executed, please wait for $(( WAIT_MINUTE - ${FLAG_STATUS: -1} )) minutes. \n"
  else
    rm -f ${NO_ACTION_FLAG}*
  fi
fi

# 鑾峰彇 Github 涓婄殑 README.md 鏂囦欢鍐呭
ONLINE="$(wget -qO- --header="Authorization: token $GH_PAT" ${GH_PROXY}https://raw.githubusercontent.com/$GH_BACKUP_USER/$GH_REPO/main/README.md | sed "/^$/d" | head -n 1)"

# 鑻ョ敤鎴峰湪 Github 鐨?README.md 閲屾敼浜嗗唴瀹瑰寘鍚叧閿瘝 backup锛屽垯瑙﹀彂瀹炴椂澶囦唤锛涗负瑙ｅ喅 Github cdn 瀵艰嚧鑾峰彇鏂囦欢鍐呭鏉ュ洖璺崇殑闂锛岃缃嚜閿佸苟妫€娴嬪埌澶囦唤鏂囦欢鍚庡欢鏃?鍒嗛挓鏂紑锛?娆?杩愯 restore.sh 鐨勬椂闂?
if [ -z "$ONLINE" ]; then
  error "\n Failed to connect to Github or README.md is empty! \n"
elif grep -qi 'backup' <<< "$ONLINE"; then
  [ ! -e ${NO_ACTION_FLAG}* ] && { $WORK_DIR/backup.sh; exit 0; }
fi

if [[ "$DASHBOARD_VERSION" =~ 0\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
  # 璇诲彇闈㈡澘鐜伴厤缃俊鎭?  CONFIG_YAML=$(cat $WORK_DIR/data/config.yaml)
  CONFIG_HTTPPORT=$(grep -i '^HTTPPort:' <<< "$CONFIG_YAML")
  CONFIG_LANGUAGE=$(grep -i '^Language:' <<< "$CONFIG_YAML")
  CONFIG_GRPCPORT=$(grep -i '^GRPCPort:' <<< "$CONFIG_YAML")
  CONFIG_GRPCHOST=$(grep -i '^GRPCHost:' <<< "$CONFIG_YAML")
  CONFIG_PROXYGRPCPORT=$(grep -i '^ProxyGRPCPort:' <<< "$CONFIG_YAML")
  CONFIG_TYPE=$(sed -n '/Type:/ s/^[ ]\+//gp' <<< "$CONFIG_YAML")
  CONFIG_ADMIN=$(sed -n '/Admin:/ s/^[ ]\+//gp' <<< "$CONFIG_YAML")
  CONFIG_CLIENTID=$(sed -n '/ClientID:/ s/^[ ]\+//gp' <<< "$CONFIG_YAML")
  CONFIG_CLIENTSECRET=$(sed -n '/ClientSecret:/ s/^[ ]\+//gp' <<< "$CONFIG_YAML")

  # 濡?dbfile 涓嶄负绌猴紝鍗充笉鏄娆″畨瑁咃紝璁板綍褰撳墠闈㈡澘鐨勪富棰樼瓑淇℃伅
  if [ -s $WORK_DIR/dbfile ]; then
    CONFIG_BRAND=$(sed -n '/brand:/s/^[ ]\+//gp' <<< "$CONFIG_YAML")
    CONFIG_COOKIENAME=$(sed -n '/cookiename:/s/^[ ]\+//gp' <<< "$CONFIG_YAML")
    CONFIG_THEME=$(sed -n '/theme:/s/^[ ]\+//gp' <<< "$CONFIG_YAML")
    CONFIG_AVGPINGCOUNT=$(grep -i 'AvgPingCount:' <<< "$CONFIG_YAML")
    CONFIG_MAXTCPPINGVALUE=$(grep -i 'MaxTCPPingValue:' <<< "$CONFIG_YAML")
  fi
fi

# 鏍规嵁浼犲弬鏍囧織浣滅浉搴旂殑澶勭悊
if [ "$1" = a ]; then
  [ "$ONLINE" = "$(cat $WORK_DIR/dbfile)" ] && exit
  [[ "$ONLINE" =~ tar\.gz$ && "$ONLINE" != "$(cat $WORK_DIR/dbfile)" ]] && FILE="$ONLINE" || exit
elif [ "$1" = f ]; then
  [[ "$ONLINE" =~ tar\.gz$ ]] && FILE="$ONLINE" || exit
elif [[ "$1" =~ tar\.gz$ ]]; then
  [[ "$FILE" =~ http.*/.*tar.gz ]] && FILE=$(awk -F '/' '{print $NF}' <<< $FILE) || FILE="$1"
elif [ -z "$1" ]; then
  BACKUP_FILE_LIST=($(wget -qO- --header="Authorization: token $GH_PAT" https://api.github.com/repos/$GH_BACKUP_USER/$GH_REPO/contents/ | awk -F '"' '/"path".*tar.gz/{print $4}' | sort -r))
  until [[ "$CHOOSE" =~ ^[1-${#BACKUP_FILE_LIST[@]}]$ ]]; do
    for i in ${!BACKUP_FILE_LIST[@]}; do echo " $[i+1]. ${BACKUP_FILE_LIST[i]} "; done
    echo ""
    [ -z "$FILE" ] && read -rp " Please choose the backup file [1-${#BACKUP_FILE_LIST[@]}]: " CHOOSE
    [[ ! "$CHOOSE" =~ ^[1-${#BACKUP_FILE_LIST[@]}]$ ]] && echo -e "\n Error input!" && sleep 1
    ((j++)) && [ $j -ge 5 ] && error "\n The choose has failed more than 5 times and the script exits. \n"
  done
  FILE=${BACKUP_FILE_LIST[$((CHOOSE-1))]}
fi

DOWNLOAD_URL=https://raw.githubusercontent.com/$GH_BACKUP_USER/$GH_REPO/main/$FILE
wget --header="Authorization: token $GH_PAT" --header='Accept: application/vnd.github.v3.raw' -O $TEMP_DIR/backup.tar.gz ${GH_PROXY}${DOWNLOAD_URL}

if [ -e $TEMP_DIR/backup.tar.gz ]; then
  if [ "$IS_DOCKER" = 1 ]; then
    hint "\n$(supervisorctl stop agent nezha grpcproxy)\n"
  else
    hint "\n Stop Nezha-dashboard \n" && cmd_systemctl disable
  fi

  # 瀹瑰櫒鐗堢殑澶囦唤鏃ф柟妗堟槸 /dashboard 鏂囦欢澶癸紝鏂版柟妗堟槸澶囦唤宸ヤ綔鐩綍 < WORK_DIR > 涓嬬殑鏂囦欢锛屾鍒ゆ柇鐢ㄤ簬鏍规嵁鍘嬬缉鍖呴噷鐨勭洰褰曟灦鏋勫垽鏂埌鍝釜鐩綍涓嬭В鍘嬶紝浠ュ吋瀹规柊鏃у浠芥柟妗?  FILE_LIST=$(tar tzf $TEMP_DIR/backup.tar.gz)
  FILE_PATH=$(sed -n 's#\(.*/\)data/sqlite\.db.*#\1#gp' <<< "$FILE_LIST")

  # 鍒ゆ柇澶囦唤鏂囦欢閲屾槸鍚︽湁鐢ㄦ埛鑷畾涔変富棰橈紝濡傛湁鍒欎竴骞惰В鍘嬪埌涓存椂鏂囦欢澶?  CUSTOM_PATH=($(sed -n "/custom/s#$FILE_PATH\(.*custom\)/.*#\1#gp" <<< "$FILE_LIST" | sort -u))
  [ ${#CUSTOM_PATH[@]} -gt 0 ] && CUSTOM_FULL_PATH=($(for k in ${CUSTOM_PATH[@]}; do echo ${FILE_PATH}${k}; done))
  echo "鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫撯啌 Restore-file list 鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫撯啌"
  tar xzvf $TEMP_DIR/backup.tar.gz -C $TEMP_DIR ${CUSTOM_FULL_PATH[@]} ${FILE_PATH}data
  echo -e "鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫戔啈 Restore-file list 鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫戔啈\n\n"

  if [[ "$DASHBOARD_VERSION" =~ 0\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
    # 杩樺師闈㈡澘閰嶇疆鐨勬渶鏂颁俊鎭?    sed -i "s@HTTPPort:.*@$CONFIG_HTTPPORT@; s@Language:.*@$CONFIG_LANGUAGE@; s@^GRPCPort:.*@$CONFIG_GRPCPORT@; s@gGRPCHost:.*@I$CONFIG_GRPCHOST@; s@ProxyGRPCPort:.*@$CONFIG_PROXYGRPCPORT@; s@Type:.*@$CONFIG_TYPE@; s@Admin:.*@$CONFIG_ADMIN@; s@ClientID:.*@$CONFIG_CLIENTID@; s@ClientSecret:.*@$CONFIG_CLIENTSECRET@I" ${TEMP_DIR}/${FILE_PATH}data/config.yaml

    # 閫昏緫鏄畨瑁呴娆′娇鐢ㄥ浠芥枃浠堕噷鐨勪富棰樹俊鎭紝涔嬪悗浣跨敤鏈湴鏈€鏂扮殑涓婚淇℃伅鍜?MaxTCPPingValue, AvgPingCount
    [[ -n "$CONFIG_BRAND" && -n "$CONFIG_COOKIENAME" && -n "$CONFIG_THEME" ]] &&
    sed -i "s@brand:.*@$CONFIG_BRAND@; s@cookiename:.*@$CONFIG_COOKIENAME@; s@theme:.*@$CONFIG_THEME@" ${TEMP_DIR}/${FILE_PATH}data/config.yaml

    [[ "$(awk '{print $NF}' <<< "$CONFIG_AVGPINGCOUNT")" =~ ^[0-9]+$ ]] && sed -i "s@AvgPingCount:.*@$CONFIG_AVGPINGCOUNT@" ${TEMP_DIR}/${FILE_PATH}data/config.yaml

    [[ "$(awk '{print $NF}' <<< "$CONFIG_MAXTCPPINGVALUE")" =~ ^[0-9]+$ ]] && sed -i "s@MaxTCPPingValue:.*@$CONFIG_MAXTCPPINGVALUE@" ${TEMP_DIR}/${FILE_PATH}data/config.yaml

    # 濡傛灉鏄鍣ㄧ増鏈細鏈夋湰鍦扮殑瀹㈡埛绔帰閽堬紝Token 灏嗘槸褰撳墠閮ㄧ讲鏃剁敓鎴愮殑18浣嶉殢鏈哄瓧绗︿覆锛岃繕鍘熺殑鏃跺€欙紝浼氭妸 sqlite.db 閲岀殑鍘嗗彶 Token 鏇存崲涓烘柊鐨勩€?    if [ "$IS_DOCKER" = 1 ]; then
      [ $(type -p sqlite3) ] || apt-get -y install sqlite3
      DB_TOKEN=$(sqlite3 ${TEMP_DIR}/${FILE_PATH}data/sqlite.db "select secret from servers where created_at='2023-04-23 13:02:00.770756566+08:00'")
      [ -n "$DB_TOKEN" ] && LOCAL_TOKEN=$(awk '/nezha-agent -s localhost/{print $(NF-1)}' /etc/supervisor/conf.d/damon.conf)
      [ "$DB_TOKEN" != "$LOCAL_TOKEN" ] && sqlite3 ${TEMP_DIR}/${FILE_PATH}data/sqlite.db "update servers set secret='${LOCAL_TOKEN}' where created_at='2023-04-23 13:02:00.770756566+08:00'"
    fi
  fi

  # 澶嶅埗涓存椂鏂囦欢鍒版寮忕殑宸ヤ綔鏂囦欢澶?  cp -rf ${TEMP_DIR}/${FILE_PATH}data/* ${WORK_DIR}/data/
  [ -d ${TEMP_DIR}/${FILE_PATH}resource ] && cp -rf ${TEMP_DIR}/${FILE_PATH}resource ${WORK_DIR}
  rm -rf ${TEMP_DIR}

  # 鍦ㄦ湰鍦拌褰曡繕鍘熸枃浠跺悕
  echo "$ONLINE" > $WORK_DIR/dbfile
  rm -f $TEMP_DIR/backup.tar.gz
  if [ "$IS_DOCKER" = 1 ]; then
    hint "\n$(supervisorctl start agent nezha grpcproxy)\n"
  else
    hint "\n Start Nezha-dashboard \n" && cmd_systemctl enable >/dev/null 2>&1
  fi
  sleep 3
else
  warning "\n Failed to download backup file! \n"
fi

if [ "$IS_DOCKER" = 1 ]; then
  [ $(supervisorctl status all | grep -c "RUNNING") = $(grep -c '\[program:.*\]' /etc/supervisor/conf.d/damon.conf) ] && info "\n All programs started! \n" || error "\n Failed to start program! \n"
else
  [ "$(systemctl is-active nezha-dashboard)" = 'active' ] && info "\n Nezha dashboard started! \n" || error "\n Failed to start Nezha dashboard! \n"
fi

