#!/usr/bin/env bash

# 鍚勫彉閲忛粯璁ゅ€?GH_PROXY='https://ghproxy.lvedong.eu.org/'
WORK_DIR='/opt/nezha/dashboard'
TEMP_DIR='/tmp/nezha'
START_PORT='5000'
NEED_PORTS=4 # web , gRPC , gRPC proxy, caddy http

trap "rm -rf $TEMP_DIR; echo -e '\n' ;exit" INT QUIT TERM EXIT

mkdir -p $TEMP_DIR

E[0]="Language:\n 1. English (default) \n 2. 绠€浣撲腑鏂?
C[0]="${E[0]}"
E[1]="Nezha Dashboard v0,v1 Combined for VPS (https://github.com/debbide/nezha-argo).\n  - Modified from Argo-Nezha-Service-Container of fscarmen \n  - Goodbye docker!\n  - Goodbye port mapping!\n  - Goodbye IPv4/IPv6 Compatibility!"
C[1]="鍝悞闈㈡澘 VPS 鍏煎v0銆乿1鐗?(https://github.com/debbide/nezha-argo)\n  - 淇敼鑷ぇ浣?fscarmen 鐨?Argo-Nezha-Service-Container \n  - 鍛婂埆 Docker锛乗n  - 鍛婂埆绔彛鏄犲皠锛乗n  - 鍛婂埆 IPv4/IPv6 鍏煎鎬э紒"
E[2]="Curren architecture \$(uname -m) is not supported. Feedback: [https://github.com/debbide/nezha-argo/issues]"
C[2]="褰撳墠鏋舵瀯 \$(uname -m) 鏆備笉鏀寔,闂鍙嶉:[https://github.com/debbide/nezha-argo/issues]"
E[3]="Input errors up to 5 times.The script is aborted."
C[3]="杈撳叆閿欒杈?娆?鑴氭湰閫€鍑?
E[4]="The script must be run as root, you can enter sudo -i and then download and run again. Feedback:[https://github.com/debbide/nezha-argo/issues]"
C[4]="蹇呴』浠oot鏂瑰紡杩愯鑴氭湰锛屽彲浠ヨ緭鍏?sudo -i 鍚庨噸鏂颁笅杞借繍琛岋紝闂鍙嶉:[https://github.com/debbide/nezha-argo/issues]"
E[5]="The script supports Debian, Ubuntu, CentOS, Alpine or Arch systems only. Feedback: [https://github.com/debbide/nezha-argo/issues]"
C[5]="鏈剼鏈彧鏀寔 Debian銆乁buntu銆丆entOS銆丄lpine 鎴?Arch 绯荤粺,闂鍙嶉:[https://github.com/debbide/nezha-argo/issues]"
E[6]="Curren operating system is \$SYS.\\\n The system lower than \$SYSTEM \${MAJOR[int]} is not supported. Feedback: [https://github.com/debbide/nezha-argo/issues]"
C[6]="褰撳墠鎿嶄綔鏄?\$SYS\\\n 涓嶆敮鎸?\$SYSTEM \${MAJOR[int]} 浠ヤ笅绯荤粺,闂鍙嶉:[https://github.com/debbide/nezha-argo/issues]"
E[7]="Install dependence-list:"
C[7]="瀹夎渚濊禆鍒楄〃:"
E[8]="All dependencies already exist and do not need to be installed additionally."
C[8]="鎵€鏈変緷璧栧凡瀛樺湪锛屼笉闇€瑕侀澶栧畨瑁?
E[9]="Please enter Github login name as the administrator:"
C[9]="璇疯緭鍏?Github 鐧诲綍鍚嶄綔涓虹鐞嗗憳:"
E[10]="About the GitHub Oauth2 application: create it at https://github.com/settings/developers, no review required, and fill in the http(s)://domain_or_IP/oauth2/callback \n Please enter the Client ID of the Oauth2 application:"
C[10]="鍏充簬 GitHub Oauth2 搴旂敤锛氬湪 https://github.com/settings/developers 鍒涘缓锛屾棤闇€瀹℃牳锛孋allback 濉?http(s)://鍩熷悕鎴朓P/oauth2/callback \n 璇疯緭鍏?Oauth2 搴旂敤鐨?Client ID:"
E[11]="Please enter the Client Secret of the Oauth2 application:"
C[11]="璇疯緭鍏?Oauth2 搴旂敤鐨?Client Secret:"
E[12]="Please enter the Argo Json or Token (You can easily get the json at: https://fscarmen.cloudflare.now.cc):"
C[12]="璇疯緭鍏?Argo Json 鎴栬€?Token (鐢ㄦ埛閫氳繃浠ヤ笅缃戠珯杞绘澗鑾峰彇 json: https://fscarmen.cloudflare.now.cc):"
E[13]="Please enter the Argo domain name:"
C[13]="璇疯緭鍏?Argo 鍩熷悕:"
E[14]="If you need to back up your database to Github regularly, please enter the name of your private Github repository, otherwise leave it blank:"
C[14]="濡傞渶瑕佸畾鏃舵妸鏁版嵁搴撳浠藉埌 Github锛岃杈撳叆 Github 绉佸簱鍚嶏紝鍚﹀垯璇风暀绌?"
E[15]="Please enter the Github username for the database \(default \$GH_USER\):"
C[15]="璇疯緭鍏ユ暟鎹簱鐨?Github 鐢ㄦ埛鍚?\(榛樿 \$GH_USER\):"
E[16]="Please enter the Github Email for the database:"
C[16]="璇疯緭鍏ユ暟鎹簱鐨?Github Email:"
E[17]="Please enter a Github PAT:"
C[17]="璇疯緭鍏?Github PAT:"
E[18]="There are variables that are not set. Installation aborted. Feedback: [https://github.com/debbide/nezha-argo/issues]"
C[18]="鍙傛暟涓嶉綈锛屽畨瑁呬腑姝紝闂鍙嶉:[https://github.com/debbide/nezha-argo/issues]"
E[19]="Exit"
C[19]="閫€鍑?
E[20]="Close Nezha dashboard"
C[20]="鍏抽棴鍝悞闈㈡澘"
E[21]="Open Nezha dashboard"
C[21]="寮€鍚摢鍚掗潰鏉?
E[22]="Argo authentication message does not match the rules, neither Token nor Json, script exits. Feedback:[https://github.com/debbide/nezha-argo/issues]"
C[22]="Argo 璁よ瘉淇℃伅涓嶇鍚堣鍒欙紝鏃笉鏄?Token锛屼篃鏄笉鏄?Json锛岃剼鏈€€鍑猴紝闂鍙嶉:[https://github.com/debbide/nezha-argo/issues]"
E[23]="Please enter the correct number"
C[23]="璇疯緭鍏ユ纭暟瀛?
E[24]="Choose:"
C[24]="璇烽€夋嫨:"
E[25]="Downloading. Please wait a minute."
C[25]="涓嬭浇涓? 璇风◢绛?
E[26]="Not install"
C[26]="鏈畨瑁?
E[27]="close"
C[27]="鍏抽棴"
E[28]="open"
C[28]="寮€鍚?
E[29]="Uninstall Nezha dashboard"
C[29]="鍗歌浇鍝悞闈㈡澘"
E[30]="Install Kiritocyz's VPS with Argo v0,v1 Combined version (https://github.com/debbide/nezha-argo)"
C[30]="瀹夎 Kiritocyz 鐨?VPS argo 甯﹁繙绋嬪浠界殑v0銆乿1鍏煎鐗?(https://github.com/debbide/nezha-argo)"
E[31]="successful"
C[31]="鎴愬姛"
E[32]="failed"
C[32]="澶辫触"
E[33]="Could not find \$NEED_PORTS free ports, script exits. Feedback:[https://github.com/debbide/nezha-argo/issues]"
C[33]="鎵句笉鍒?\$NEED_PORTS 涓彲鐢ㄧ鍙ｏ紝鑴氭湰閫€鍑猴紝闂鍙嶉:[https://github.com/debbide/nezha-argo/issues]"
E[34]="Important!!! Please turn on gRPC at the Network of the relevant Cloudflare domain, otherwise the client data will not work! See the tutorial for details: [https://github.com/debbide/nezha-argo]"
C[34]="閲嶈!!! 璇峰埌 Cloudflare 鐩稿叧鍩熷悕鐨?Network 澶勬墦寮€ gRPC 鍔熻兘锛屽惁鍒欏鎴风鏁版嵁涓嶉€?鍏蜂綋鍙弬鐓ф暀绋? [https://github.com/debbide/nezha-argo]"
E[35]="Please add two Public hostnames to Cloudnflare Tunnel: \\\n 1. ------------------------ \\\n Public hostname: \$ARGO_DOMAIN \\\n Path: proto.NezhaService \\\n Type: HTTPS \\\n URL: localhost:\$GRPC_PROXY_PORT \\\n Additional application settings ---\> TLS: Enable [No TLS Verify] and [HTTP2 connection] \\\n\\\n 2. ------------------------ \\\n Public hostname: \$ARGO_DOMAIN \\\n Type: HTTP \\\n URL: localhost:\$WEB_PORT"
C[35]="璇峰湪 Cloudnflare Tunnel 閲屽鍔犱袱涓?Public hostnames: \\\n 1. ------------------------ \\\n Public hostname: \$ARGO_DOMAIN \\\n Path: proto.NezhaService \\\n Type: HTTPS \\\n URL: localhost:\$GRPC_PROXY_PORT \\\n Additional application settings ---\> TLS: 寮€鍚?[No TLS Verify] 鍜?[HTTP2 connection] 杩欎袱澶勫姛鑳?\\\n\\\n 2. ------------------------ \\\n Public hostname: \$ARGO_DOMAIN \\\n Type: HTTP \\\n URL: localhost:\$WEB_PORT"
E[36]="Downloading the \${FAILED[*]} failed. Installation aborted. Feedback: [https://github.com/debbide/nezha-argo/issues]"
C[36]="涓嬭浇 \${FAILED[*]} 澶辫触锛屽畨瑁呬腑姝紝闂鍙嶉:[https://github.com/debbide/nezha-argo/issues]"
E[37]="Install Nezha's official VPS or docker version (https://github.com/naiba/nezha)"
C[37]="瀹夎鍝悞瀹樻柟 VPS 鎴?Docker 鐗堟湰 (https://github.com/naiba/nezha)"
E[38]="Please choose gRPC proxy mode(v1 use Caddy):\n 1. Caddy (default)\n 2. Nginx\n 3. gRPCwebProxy"
C[38]="璇烽€夋嫨 gRPC 浠ｇ悊妯″紡(v1璇蜂娇鐢–addy):\n 1. Caddy (榛樿)\n 2. Nginx\n 3. gRPCwebProxy"
E[39]="To uninstall Nginx press [y], it is not uninstalled by default:"
C[39]="濡傝鍗歌浇 Nginx 璇锋寜 [y]锛岄粯璁や笉鍗歌浇:"
E[40]="Please enter the specified Nezha dashboard version, it will be fixed in this version, if you skip it, the latest v1 will be used. :"
C[40]="璇峰～鍏ユ寚瀹氶潰鏉跨増鏈?鍚庣画灏嗗浐瀹氬湪璇ョ増鏈紝璺宠繃鍒欎娇鐢╲1鏈€鏂扮増"
E[41]="Default: enable automatic online synchronization of the latest backup.sh and restore.sh scripts. If you do not want this feature, enter [n]:"
C[41]="榛樿寮€鍚嚜鍔ㄥ湪绾垮悓姝ユ渶鏂?backup.sh 鍜?restore.sh 鑴氭湰鐨勫姛鑳斤紝濡備笉闇€瑕佽鍔熻兘锛岃杈撳叆 [n]:"
E[42]="The DASHBOARD_VERSION variable should be in a format like v0.00.00 or left blank. Please check."
C[42]="鍙橀噺 DASHBOARD_VERSION 蹇呴』浠?v0.00.00 鐨勬牸寮忔垨鑰呯暀绌猴紝璇锋鏌?
E[43]="Please enter the required backup time (default is Cron expression: 0 4 * * *):"
C[43]="璇疯緭鍏ラ渶瑕佺殑澶囦唤鏃堕棿(榛樿涓篊ron琛ㄨ揪寮? 0 4 * * *):"
E[44]="Please enter the number of backups to be retained in the backup repository (default is 5):"
C[44]="璇疯緭鍏ュ浠戒粨搴撻噷鎵€淇濈暀鐨勫浠芥暟閲?榛樿涓?5):"

# 鑷畾涔夊瓧浣撳僵鑹诧紝read 鍑芥暟
warning() { echo -e "\033[31m\033[01m$*\033[0m"; }  # 绾㈣壊
error() { echo -e "\033[31m\033[01m$*\033[0m" && exit 1; } # 绾㈣壊
info() { echo -e "\033[32m\033[01m$*\033[0m"; }   # 缁胯壊
hint() { echo -e "\033[33m\033[01m$*\033[0m"; }   # 榛勮壊
reading() { read -rp "$(info "$1")" "$2"; }
text() { grep -q '\$' <<< "${E[$*]}" && eval echo "\$(eval echo "\${${L}[$*]}")" || eval echo "\${${L}[$*]}"; }

# 閫夋嫨涓嫳璇█
select_language() {
  if [ -z "$L" ]; then
    case $(cat $WORK_DIR/language 2>&1) in
      E ) L=E ;;
      C ) L=C ;;
      * ) [ -z "$L" ] && L=E && hint "\n $(text 0) \n" && reading " $(text 24) " LANGUAGE
      [ "$LANGUAGE" = 2 ] && L=C ;;
    esac
  fi
}

check_root() {
  [ "$(id -u)" != 0 ] && error "\n $(text 4) \n"
}

check_arch() {
  # 鍒ゆ柇澶勭悊鍣ㄦ灦鏋?  case "$(uname -m)" in
    aarch64|arm64 )
      ARCH=arm64
      ;;
    x86_64|amd64 )
      ARCH=amd64
      ;;
    armv7* )
      ARCH=arm
      ;;
    * ) error " $(text 2) "
  esac
}

# 妫€鏌ュ彲鐢?port 鍑芥暟锛岃姹?涓?check_port() {
  until [ "$START_PORT" -gt 65530 ]; do
    if [ "$SYSTEM" = 'Alpine' ]; then
      netstat -an | awk '/:[0-9]+/{print $4}' | awk -F ":" '{print $NF}' | grep -q $START_PORT || FREE_PORT+=("$START_PORT")
    else
      lsof -i:$START_PORT >/dev/null 2>&1 || FREE_PORT+=("$START_PORT")
    fi
    [ "${#FREE_PORT[@]}" = $NEED_PORTS ] && break
    ((START_PORT++))
  done

  if  [ "${#FREE_PORT[@]}" = $NEED_PORTS ]; then
    GRPC_PROXY_PORT=${FREE_PORT[0]}
    WEB_PORT=${FREE_PORT[1]}
    GRPC_PORT=${FREE_PORT[2]}
    CADDY_HTTP_PORT=${FREE_PORT[3]}
  else
    error "\n $(text 33) \n"
  fi
}

# 鏌ュ畨瑁呭強杩愯鐘舵€侊紝涓嬫爣0: argo锛屼笅鏍?: app锛?鐘舵€佺爜: 0 鏈畨瑁咃紝 1 宸插畨瑁呮湭杩愯锛?2 杩愯涓?check_install() {
  STATUS=$(text 26) && [ -s /etc/systemd/system/nezha-dashboard.service ] && STATUS=$(text 27) && [ "$(systemctl is-active nezha-dashboard)" = 'active' ] && STATUS=$(text 28)

  if [ "$STATUS" = "$(text 26)" ]; then
    { wget -qO $TEMP_DIR/cloudflared ${GH_PROXY}https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$ARCH >/dev/null 2>&1 && chmod +x $TEMP_DIR/cloudflared >/dev/null 2>&1; }&
  fi
}

# 涓轰簡閫傞厤 alpine锛屽畾涔?cmd_systemctl 鐨勫嚱鏁?cmd_systemctl() {
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
      cat > /etc/local.d/nezha-dashboard.start << EOF
#!/usr/bin/env bash

systemctl start nezha-dashboard
EOF
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

check_system_info() {
  [ -s /etc/os-release ] && SYS="$(grep -i pretty_name /etc/os-release | cut -d \" -f2)"
  [[ -z "$SYS" && -x "$(type -p hostnamectl)" ]] && SYS="$(hostnamectl | grep -i system | cut -d : -f2)"
  [[ -z "$SYS" && -x "$(type -p lsb_release)" ]] && SYS="$(lsb_release -sd)"
  [[ -z "$SYS" && -s /etc/lsb-release ]] && SYS="$(grep -i description /etc/lsb-release | cut -d \" -f2)"
  [[ -z "$SYS" && -s /etc/redhat-release ]] && SYS="$(grep . /etc/redhat-release)"
  [[ -z "$SYS" && -s /etc/issue ]] && SYS="$(grep . /etc/issue | cut -d '\' -f1 | sed '/^[ ]*$/d')"

  REGEX=("debian" "ubuntu" "centos|red hat|kernel|oracle linux|alma|rocky" "amazon linux" "arch linux" "alpine")
  RELEASE=("Debian" "Ubuntu" "CentOS" "CentOS" "Arch" "Alpine")
  EXCLUDE=("")
  MAJOR=("9" "16" "7" "7" "" "")
  PACKAGE_UPDATE=("apt -y update" "apt -y update" "yum -y update" "yum -y update" "pacman -Sy" "apk update -f")
  PACKAGE_INSTALL=("apt -y install" "apt -y install" "yum -y install" "yum -y install" "pacman -S --noconfirm" "apk add --no-cache")
  PACKAGE_UNINSTALL=("apt -y autoremove" "apt -y autoremove" "yum -y autoremove" "yum -y autoremove" "pacman -Rcnsu --noconfirm" "apk del -f")

  for int in "${!REGEX[@]}"; do [[ $(tr 'A-Z' 'a-z' <<< "$SYS") =~ ${REGEX[int]} ]] && SYSTEM="${RELEASE[int]}" && break; done
  [ -z "$SYSTEM" ] && error " $(text 5) "

  # 鍏堟帓闄?EXCLUDE 閲屽寘鎷殑鐗瑰畾绯荤粺锛屽叾浠栫郴缁熼渶瑕佷綔澶у彂琛岀増鏈殑姣旇緝
  for ex in "${EXCLUDE[@]}"; do [[ ! $(tr 'A-Z' 'a-z' <<< "$SYS")  =~ $ex ]]; done &&
  [[ "$(echo "$SYS" | sed "s/[^0-9.]//g" | cut -d. -f1)" -lt "${MAJOR[int]}" ]] && error " $(text 6) "
}

# 妫€娴嬫槸鍚﹂渶瑕佸惎鐢?Github CDN锛屽鑳界洿鎺ヨ繛閫氾紝鍒欎笉浣跨敤
check_cdn() {
  [ -n "$GH_PROXY" ] && wget --server-response --quiet --output-document=/dev/null --no-check-certificate --tries=2 --timeout=3 https://raw.githubusercontent.com/debbide/nezha-argo/main/README.md >/dev/null 2>&1 && unset GH_PROXY
}

check_dependencies() {
  # 濡傛灉鏄?Alpine锛屽厛鍗囩骇 wget 锛屽畨瑁?systemctl-py 鐗?  if [ "$SYSTEM" = 'Alpine' ]; then
    CHECK_WGET=$(wget 2>&1 | head -n 1)
    grep -qi 'busybox' <<< "$CHECK_WGET" && ${PACKAGE_INSTALL[int]} wget >/dev/null 2>&1

    DEPS_CHECK=("bash" "rc-update" "git" "ss" "openssl" "python3" "unzip")
    DEPS_INSTALL=("bash" "openrc" "git" "iproute2" "openssl" "python3" "unzip")
    for ((g=0; g<${#DEPS_CHECK[@]}; g++)); do [ ! -x "$(type -p ${DEPS_CHECK[g]})" ] && [[ ! "${DEPS[@]}" =~ "${DEPS_INSTALL[g]}" ]] && DEPS+=(${DEPS_INSTALL[g]}); done
    if [ "${#DEPS[@]}" -ge 1 ]; then
      info "\n $(text 7) ${DEPS[@]} \n"
      ${PACKAGE_UPDATE[int]} >/dev/null 2>&1
      ${PACKAGE_INSTALL[int]} ${DEPS[@]} >/dev/null 2>&1
    else
      info "\n $(text 8) \n"
    fi

    [ ! -x "$(type -p systemctl)" ] && wget ${GH_PROXY}https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py -O /bin/systemctl && chmod a+x /bin/systemctl

  # 闈?Alpine 绯荤粺瀹夎鐨勪緷璧?  else
    # 妫€娴?Linux 绯荤粺鐨勪緷璧栵紝鍗囩骇搴撳苟閲嶆柊瀹夎渚濊禆
    DEPS_CHECK=("wget" "systemctl" "ss" "git" "timedatectl" "openssl" "unzip")
    DEPS_INSTALL=("wget" "systemctl" "iproute2" "git" "timedatectl" "openssl" "unzip")
    for ((g=0; g<${#DEPS_CHECK[@]}; g++)); do [ ! -x "$(type -p ${DEPS_CHECK[g]})" ] && [[ ! "${DEPS[@]}" =~ "${DEPS_INSTALL[g]}" ]] && DEPS+=(${DEPS_INSTALL[g]}); done
    if [ "${#DEPS[@]}" -ge 1 ]; then
      info "\n $(text 7) ${DEPS[@]} \n"
      ${PACKAGE_UPDATE[int]} >/dev/null 2>&1
      ${PACKAGE_INSTALL[int]} ${DEPS[@]} >/dev/null 2>&1
    else
      info "\n $(text 8) \n"
    fi
  fi
}

# 鐢宠鑷璇佷功
certificate() {
  openssl genrsa -out ${TEMP_DIR}/nezha.key 2048 >/dev/null 2>&1
  openssl req -new -subj "/CN=$ARGO_DOMAIN" -key ${TEMP_DIR}/nezha.key -out ${TEMP_DIR}/nezha.csr >/dev/null 2>&1
  openssl x509 -req -days 36500 -in ${TEMP_DIR}/nezha.csr -signkey ${TEMP_DIR}/nezha.key -out ${TEMP_DIR}/nezha.pem >/dev/null 2>&1
}

dashboard_variables() {
# 璇㈤棶鐗堟湰鑷姩鍚庡彴涓嬭浇
  [ -z "$DASHBOARD_VERSION" ] && reading "\n (1/14) $(text 40) " DASHBOARD_VERSION
  if [ -z "$DASHBOARD_VERSION" ]; then
    { wget -qO $TEMP_DIR/dashboard.zip ${GH_PROXY}https://github.com/nezhahq/nezha/releases/latest/download/dashboard-linux-$ARCH.zip >/dev/null 2>&1; }&
  elif [[ "$DASHBOARD_VERSION" =~ [0-1]{1}\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
    DASHBOARD_LATEST=$(sed 's/[A-Za-z]//; s/^/v&/' <<< "$DASHBOARD_VERSION")
    { wget -qO $TEMP_DIR/dashboard.zip ${GH_PROXY}https://github.com/naiba/nezha/releases/download/$DASHBOARD_LATEST/dashboard-linux-$ARCH.zip >/dev/null 2>&1; }&
  else
    error "\n $(text 42) \n"
  fi

  [ -z "$GH_USER" ] && reading " (2/14) $(text 9) " GH_USER
  [ -z "$GH_CLIENTID" ] && reading "\n (3/14) $(text 10) " GH_CLIENTID
  [ -z "$GH_CLIENTSECRET" ] && reading "\n (4/14) $(text 11) " GH_CLIENTSECRET
  local a=5
  until [[ "$ARGO_AUTH" =~ TunnelSecret || "$ARGO_AUTH" =~ ^[A-Z0-9a-z=]{120,250}$ || "$ARGO_AUTH" =~ .*cloudflared.*service[[:space:]]+install[[:space:]]+[A-Z0-9a-z=]{1,100} ]]; do
    [ "$a" = 0 ] && error "\n $(text 3) \n" || reading "\n (5/14) $(text 12) " ARGO_AUTH
    if [[ "$ARGO_AUTH" =~ TunnelSecret ]]; then
      ARGO_JSON=${ARGO_AUTH//[ ]/}
    elif [[ "$ARGO_AUTH" =~ ^[A-Z0-9a-z=]{120,250}$ ]]; then
      ARGO_TOKEN=$ARGO_AUTH
    elif [[ "$ARGO_AUTH" =~ .*cloudflared.*service[[:space:]]+install[[:space:]]+[A-Z0-9a-z=]{1,100} ]]; then
      ARGO_TOKEN=$(awk -F ' ' '{print $NF}' <<< "$ARGO_AUTH")
    else
      warning "\n $(text 22) \n"
    fi
    ((a--)) || true
  done

  # 澶勭悊鍙兘杈撳叆鐨勯敊璇紝鍘绘帀寮€澶村拰缁撳熬鐨勭┖鏍硷紝鍘绘帀鏈€鍚庣殑 :
  [ -z "$ARGO_DOMAIN" ] && reading "\n (6/14) $(text 13) " ARGO_DOMAIN
  ARGO_DOMAIN=$(sed 's/[ ]*//g; s/:[ ]*//' <<< "$ARGO_DOMAIN")
  { certificate; }&

  # # 鐢ㄦ埛閫夋嫨浣跨敤 gRPC 鍙嶄唬鏂瑰紡: Nginx / Caddy / grpcwebproxy锛岄粯璁や负 Caddy
  [ -z "$REVERSE_PROXY_MODE" ] && info "\n (7/14) $(text 38) \n" && reading " $(text 24) " REVERSE_PROXY_CHOOSE
  case "$REVERSE_PROXY_CHOOSE" in
    2 ) REVERSE_PROXY_MODE=nginx ;;
    3 ) REVERSE_PROXY_MODE=grpcwebproxy ;;
    * ) REVERSE_PROXY_MODE=caddy ;;
  esac

  if [[ "$DASHBOARD_VERSION" =~ 0\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
    [[ -z "$GH_USER" || -z "$GH_CLIENTID" || -z "$GH_CLIENTSECRET" || -z "$ARGO_AUTH" || -z "$ARGO_DOMAIN" ]] && error "\n $(text 18) "
  else
    [[ -z "$ARGO_AUTH" || -z "$ARGO_DOMAIN" ]] && error "\n $(text 18) "
  fi

  [ -z "$GH_REPO"] && reading "\n (8/14) $(text 14) " GH_REPO
  if [ -n "$GH_REPO" ]; then
    [ -z "$GH_BACKUP_USER" ] && reading "\n (9/14) $(text 15) " GH_BACKUP_USER
    GH_BACKUP_USER=${GH_BACKUP_USER:-$GH_USER}
    [ -z "$GH_EMAIL"] && reading "\n (10/14) $(text 16) " GH_EMAIL
    [ -z "$GH_PAT"] && reading "\n (11/14) $(text 17) " GH_PAT
    [ -z "$BACKUP_TIME"] && reading "\n (12/14) $(text 43) " BACKUP_TIME
    [ -z "$BACKUP_NUM"] && reading "\n (13/14) $(text 44) " BACKUP_NUM
  fi
  if [ -z "$BACKUP_TIME" ]; then
      BACKUP_TIME="0 4 * * *"
  fi
  if [ -z "$BACKUP_NUM" ]; then
        BACKUP_NUM=5
  fi
  [ -z "$AUTO_RENEW_OR_NOT"] && reading "\n (14/14) $(text 41) " AUTO_RENEW_OR_NOT
  grep -qiw 'n' <<< "$AUTO_RENEW_OR_NOT" && IS_AUTO_RENEW=#
}

# 瀹夎闈㈡澘
install() {
  dashboard_variables

  check_port

  hint "\n $(text 25) "

  # 鏍规嵁 caddy锛実rpcwebproxy 鎴?nginx 浣滃鐞?  if  [ "$REVERSE_PROXY_MODE" = 'caddy' ]; then
    local CADDY_LATEST=$(wget -qO- "${GH_PROXY}https://api.github.com/repos/caddyserver/caddy/releases/latest" | awk -F [v\"] '/"tag_name"/{print $5}' || echo '2.7.6')
    wget -c ${GH_PROXY}https://github.com/caddyserver/caddy/releases/download/v${CADDY_LATEST}/caddy_${CADDY_LATEST}_linux_${ARCH}.tar.gz -qO- | tar xz -C $TEMP_DIR caddy >/dev/null 2>&1
    GRPC_PROXY_RUN="$WORK_DIR/caddy run --config $WORK_DIR/Caddyfile --watch"
    cat > $TEMP_DIR/Caddyfile  << EOF
{
    http_port $CADDY_HTTP_PORT
}

:$GRPC_PROXY_PORT {
    reverse_proxy {
        to localhost:$GRPC_PORT
        transport http {
            versions h2c 2
        }
    }
    tls $WORK_DIR/nezha.pem $WORK_DIR/nezha.key
}
EOF
    if [[ -z "$DASHBOARD_VERSION" || "$DASHBOARD_VERSION" =~ 1\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
      cat >> $TEMP_DIR/Caddyfile  << EOF
:$WEB_PORT {
    reverse_proxy {
        to localhost:$GRPC_PORT
    }
}
EOF
    fi
  
  elif [ "$REVERSE_PROXY_MODE" = 'nginx' ]; then
    [ ! -x "$(type -p nginx)" ] && ${PACKAGE_INSTALL[int]} nginx
    GRPC_PROXY_RUN="nginx -c $WORK_DIR/nginx.conf"
    cat > $TEMP_DIR/nginx.conf  << EOF
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;
events {
        worker_connections 768;
        # multi_accept on;
}
http {
  upstream grpcservers {
    server localhost:$GRPC_PORT;
    keepalive 1024;
  }
  server {
    listen 127.0.0.1:$GRPC_PROXY_PORT ssl http2;
    server_name $ARGO_DOMAIN;
    ssl_certificate          $WORK_DIR/nezha.pem;
    ssl_certificate_key      $WORK_DIR/nezha.key;
    underscores_in_headers on;
    location / {
      grpc_read_timeout 300s;
      grpc_send_timeout 300s;
      grpc_socket_keepalive on;
      grpc_pass grpc://grpcservers;
    }
    access_log  /dev/null;
    error_log   /dev/null;
  }
}
EOF
  elif [ "$REVERSE_PROXY_MODE" = 'grpcwebproxy' ]; then
    wget -c ${GH_PROXY}https://github.com/fscarmen2/Argo-Nezha-Service-Container/releases/download/grpcwebproxy/grpcwebproxy-linux-$ARCH.tar.gz -qO- | tar xz -C $TEMP_DIR >/dev/null 2>&1
    chmod +x $TEMP_DIR/grpcwebproxy
    GRPC_PROXY_RUN="nohup ${WORK_DIR}/grpcwebproxy --run_http_server=false --server_tls_cert_file=${WORK_DIR}/nezha.pem --server_tls_key_file=${WORK_DIR}/nezha.key --server_http_tls_port=$GRPC_PROXY_PORT --backend_addr=localhost:${GRPC_PORT} --backend_tls_noverify --server_http_max_read_timeout=300s --server_http_max_write_timeout=300s >/dev/null 2>&1 &"
  fi

  wait

  # unzip 瑙ｅ帇闈㈡澘涓诲簲鐢?  if [ "$STATUS" = "$(text 26)" ]; then
    unzip -o -q $TEMP_DIR/dashboard.zip -d $TEMP_DIR 2>&1
    [ -d /tmp/dist ] && mv $TEMP_DIR/dist/dashboard-linux-$ARCH $TEMP_DIR/dashboard-linux-$ARCH && rm -rf $TEMP_DIR/dist
    chmod +x $TEMP_DIR/dashboard-linux-$ARCH 2>&1
    mv -f $TEMP_DIR/dashboard-linux-$ARCH $TEMP_DIR/app >/dev/null 2>&1
  fi

  # 妫€娴嬩笅杞界殑鏂囦欢鎴栨枃浠跺す鏄惁榻?  for f in ${TEMP_DIR}/{cloudflared,app,nezha.key,nezha.csr,nezha.pem}; do
    [ ! -s "$f" ] && FAILED+=("${f//${TEMP_DIR}\//}")
  done
  case "$REVERSE_PROXY_MODE" in
    caddy ) [ ! -s $TEMP_DIR/caddy ] && FAILED+=("caddy") ;;
    grpcwebproxy ) [ ! -s $TEMP_DIR/grpcwebproxy ] && FAILED+=("grpcwebproxy") ;;
  esac
  [ "${#FAILED[@]}" -gt 0 ] && error "\n $(text 36) "

  # 浠庝复鏃舵枃浠跺す澶嶅埗宸蹭笅杞界殑鎵€鏈夊埌宸ヤ綔鏂囦欢澶?  [ ! -d ${WORK_DIR}/data ] && mkdir -p ${WORK_DIR}/data
  cp -r $TEMP_DIR/{app,cloudflared,nezha.*} $WORK_DIR
  case "$REVERSE_PROXY_MODE" in
    caddy ) cp -f $TEMP_DIR/caddy $TEMP_DIR/Caddyfile $WORK_DIR ;;
    nginx ) cp -f $TEMP_DIR/nginx.conf $WORK_DIR ;;
    grpcwebproxy ) cp -f $TEMP_DIR/grpcwebproxy $WORK_DIR ;;
  esac
  rm -rf $TEMP_DIR

  # 鏍规嵁鍙傛暟鐢熸垚鍝悞鏈嶅姟绔厤缃枃浠?  if [ "$L" = 'C' ]; then
    DASHBOARD_LANGUAGE='zh-CN'
    if [ "$(date | awk '{print $(NF-1)}')" != 'CST' ]; then
      if [ "$SYSTEM" = 'Alpine' ]; then
          [ ! -s /usr/share/zoneinfo/Asia/Shanghai ] && apk add tzdata >/dev/null 2>&1
          cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
          echo "Asia/Shanghai" > /etc/timezone
      else
        timedatectl set-timezone Asia/Shanghai
      fi
    fi
  else
    DASHBOARD_LANGUAGE='en-US'
  fi

  if [[ "$DASHBOARD_VERSION" =~ 0\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
    cat > ${WORK_DIR}/data/config.yaml << EOF
Debug: false
HTTPPort: $WEB_PORT
Language: $DASHBOARD_LANGUAGE
GRPCPort: $GRPC_PORT
GRPCHost: $ARGO_DOMAIN
ProxyGRPCPort: 443
TLS: true
Oauth2:
  Type: "github" #Oauth2 鐧诲綍鎺ュ叆绫诲瀷锛実ithub/gitlab/jihulab/gitee/gitea
  Admin: "$GH_USER" #绠＄悊鍛樺垪琛紝鍗婅閫楀彿闅斿紑
  ClientID: "$GH_CLIENTID" # 鍦?https://github.com/settings/developers 鍒涘缓锛屾棤闇€瀹℃牳 Callback 濉?http(s)://鍩熷悕鎴朓P/oauth2/callback
  ClientSecret: "$GH_CLIENTSECRET"
  Endpoint: "" # 濡俫itea鑷缓闇€瑕佽缃?Site:
  Brand: "Nezha Probe"
  CookieName: "nezha-dashboard" #娴忚鍣?Cookie 瀛楁鍚嶏紝鍙笉鏀?  Theme: "default"
EOF
  else
    LOCAL_TOKEN=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 32)
    cat > ${WORK_DIR}/data/config.yaml << EOF
agent_secret_key: $LOCAL_TOKEN
debug: false
listen_port: $GRPC_PORT
language: zh-CN
site_name: "Nezha Probe"
install_host: $ARGO_DOMAIN:443
location: Asia/Shanghai
tls: true
EOF
    if [[ -n "$GH_CLIENTID" && -n "$GH_CLIENTSECRET" ]]; then
      cat >> ${WORK_DIR}/data/config.yaml << EOF
oauth2:
   admin: ["$GH_USER"]
   GitHub:
     client_id: "$GH_CLIENTID"
     client_secret: "$GH_CLIENTSECRET"
     endpoint:
       auth_url: "https://github.com/login/oauth/authorize"
       token_url: "https://github.com/login/oauth/access_token"
     user_info_url: "https://api.github.com/user"
     user_id_path: "id"
EOF
    fi
  fi

  # 鍒ゆ柇 ARGO_AUTH 涓?json 杩樻槸 token
  # 濡備负 json 灏嗙敓鎴?argo.json 鍜?argo.yml 鏂囦欢
  if [ -n "$ARGO_JSON" ]; then
    ARGO_RUN="${WORK_DIR}/cloudflared tunnel --edge-ip-version auto --config ${WORK_DIR}/argo.yml run"

    echo "$ARGO_JSON" > ${WORK_DIR}/argo.json

    cat > ${WORK_DIR}/argo.yml << EOF
tunnel: $(cut -d '"' -f12 <<< "$ARGO_JSON")
credentials-file: ${WORK_DIR}/argo.json
protocol: http2

ingress:
  - hostname: $ARGO_DOMAIN
    service: https://localhost:$GRPC_PROXY_PORT
    path: /proto.NezhaService/*
    originRequest:
      http2Origin: true
      noTLSVerify: true
  - hostname: $ARGO_DOMAIN
    service: http://localhost:$WEB_PORT
  - service: http_status:404
EOF

  # 濡備负 token 鏃?  elif [ -n "$ARGO_TOKEN" ]; then
    ARGO_RUN="${WORK_DIR}/cloudflared tunnel --edge-ip-version auto --protocol http2 run --token ${ARGO_TOKEN}"
  fi

  # 鐢熸垚搴旂敤鍚姩鍋滄鑴氭湰鍙婅繘绋嬪畧鎶?  cat > ${WORK_DIR}/run.sh << EOF
#!/usr/bin/env bash
SYSTEM=$SYSTEM

if [ "\$1" = 'start' ]; then
  cd ${WORK_DIR}

  $GRPC_PROXY_RUN >/dev/null 2>&1 &

  ${WORK_DIR}/app >/dev/null 2>&1 &

  $ARGO_RUN

elif [ "\$1" = 'stop' ]; then
  [ "\$SYSTEM" = 'Alpine' ] && ps -ef | awk '/\/opt\/nezha\/dashboard\/(cloudflared|grpcwebproxy|caddy|app)/{print \$1}' | xargs kill -9 || ps -ef | awk '/\/opt\/nezha\/dashboard\/(cloudflared|grpcwebproxy|caddy|app)/{print \$2}' | xargs kill -9
fi
EOF

  cat > /etc/systemd/system/nezha-dashboard.service << EOF
[Unit]
Description=Nezha Argo for VPS
After=network.target
Documentation=https://github.com/debbide/nezha-argo

[Service]
Type=simple
NoNewPrivileges=yes
TimeoutStartSec=0
ExecStart=${WORK_DIR}/run.sh start
ExecStopPost=${WORK_DIR}/run.sh stop
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

  # 鐢熸垚 backup.sh 鏂囦欢鐨勬楠? - 璁剧疆鐜鍙橀噺
  cat > ${WORK_DIR}/backup.sh << EOF
#!/usr/bin/env bash

# backup.sh 浼犲弬 a 鑷姩杩樺師锛?浼犲弬 m 鎵嬪姩杩樺師锛?浼犲弬 f 寮哄埗鏇存柊闈㈡澘 app 鏂囦欢鍙?cloudflared 鏂囦欢锛屽苟澶囦唤鏁版嵁鑷虫垚澶囦唤搴?
GH_PROXY=$GH_PROXY
GH_PAT=$GH_PAT
GH_BACKUP_USER=$GH_BACKUP_USER
GH_EMAIL=$GH_EMAIL
GH_REPO=$GH_REPO
SYSTEM=$SYSTEM
ARCH=$ARCH
WORK_DIR=$WORK_DIR
DAYS=$BACKUP_NUM
IS_DOCKER=0
DASHBOARD_VERSION=$DASHBOARD_VERSION

########
EOF

  # 鐢熸垚 backup.sh 鏂囦欢鐨勬楠? - 鍦ㄧ嚎鑾峰彇 template/bakcup.sh 妯℃澘鐢熸垚瀹屾暣 backup.sh 鏂囦欢
  wget -qO- ${GH_PROXY}https://raw.githubusercontent.com/debbide/nezha-argo/main/template/backup.sh | sed '1,/^########/d' >> ${WORK_DIR}/backup.sh

  if [[ -n "$GH_BACKUP_USER" && -n "$GH_REPO" && -n "$GH_PAT" ]]; then
    # 鐢熸垚杩樺師鏁版嵁鑴氭湰
    touch ${WORK_DIR}/dbfile
    # 鐢熸垚 restore.sh 鏂囦欢鐨勬楠? - 璁剧疆鐜鍙橀噺
    cat > ${WORK_DIR}/restore.sh << EOF
#!/usr/bin/env bash

# restore.sh 浼犲弬 a 鑷姩杩樺師 README.md 璁板綍鐨勬枃浠讹紝褰撴湰鍦颁笌杩滅▼璁板綍鏂囦欢涓€鏍锋椂涓嶈繕鍘燂紱 浼犲弬 f 涓嶇鏈湴璁板綍鏂囦欢锛屽己鍒惰繕鍘熸垚澶囦唤搴撻噷 README.md 璁板綍鐨勬枃浠讹紱 浼犲弬 dashboard-***.tar.gz 杩樺師鎴愬浠藉簱閲岀殑璇ユ枃浠讹紱涓嶅甫鍙傛暟鍒欒姹傞€夋嫨澶囦唤搴撻噷鐨勬枃浠跺悕

GH_PROXY=$GH_PROXY
GH_PAT=$GH_PAT
GH_BACKUP_USER=$GH_BACKUP_USER
GH_REPO=$GH_REPO
SYSTEM=$SYSTEM
WORK_DIR=$WORK_DIR
TEMP_DIR=/tmp/restore_temp
NO_ACTION_FLAG=/tmp/flag
IS_DOCKER=0

########
EOF
    # 鐢熸垚 restore.sh 鏂囦欢鐨勬楠? - 鍦ㄧ嚎鑾峰彇 template/restore.sh 妯℃澘鐢熸垚瀹屾暣 restore.sh 鏂囦欢
    wget -qO- ${GH_PROXY}https://raw.githubusercontent.com/debbide/nezha-argo/main/template/restore.sh | sed '1,/^########/d' >> ${WORK_DIR}/restore.sh
  fi

  # 鐢熸垚 renew.sh 鏂囦欢鐨勬楠? - 璁剧疆鐜鍙橀噺
  cat > ${WORK_DIR}/renew.sh << EOF
#!/usr/bin/env bash

GH_PROXY=$GH_PROXY
WORK_DIR=$WORK_DIR
TEMP_DIR=/tmp/renew

########
EOF

  # 鐢熸垚 renew.sh 鏂囦欢鐨勬楠? - 鍦ㄧ嚎鑾峰彇 template/renew.sh 妯℃澘鐢熸垚瀹屾暣 renew.sh 鏂囦欢
  wget -qO- ${GH_PROXY}https://raw.githubusercontent.com/debbide/nezha-argo/main/template/renew.sh | sed '1,/^########/d' >> ${WORK_DIR}/renew.sh

  # 鐢熸垚瀹氭椂浠诲姟: 1.姣忓ぉ鍖椾含鏃堕棿 3:30:00 鏇存柊澶囦唤鍜岃繕鍘熸枃浠讹紝2.姣忓ぉ鍖椾含鏃堕棿 4:00:00 澶囦唤涓€娆★紝骞堕噸鍚?cron 鏈嶅姟锛?3.姣忓垎閽熻嚜鍔ㄦ娴嬪湪绾垮浠芥枃浠堕噷鐨勫唴瀹?  if [ "$SYSTEM" = 'Alpine' ]; then
    [ -s $WORK_DIR/renew.sh ] && ! grep -q "${WORK_DIR}/renew.sh" /var/spool/cron/crontabs/root && echo "${IS_AUTO_RENEW}30       3       *       *       *       bash ${WORK_DIR}/renew.sh a" >> /var/spool/cron/crontabs/root
    [ -s $WORK_DIR/backup.sh ] && ! grep -q "${WORK_DIR}/backup.sh" /var/spool/cron/crontabs/root && echo "${BACKUP_TIME}       bash ${WORK_DIR}/backup.sh a" >> /var/spool/cron/crontabs/root
    [ -s $WORK_DIR/restore.sh ] && ! grep -q "${WORK_DIR}/restore.sh" /var/spool/cron/crontabs/root && echo "*       *       *       *       *       bash ${WORK_DIR}/restore.sh a" >> /var/spool/cron/crontabs/root
  else
    [ -s $WORK_DIR/renew.sh ] && ! grep -q "${WORK_DIR}/renew.sh" /etc/crontab && echo "${IS_AUTO_RENEW}30 3 * * * root bash ${WORK_DIR}/renew.sh" >> /etc/crontab
    [ -s $WORK_DIR/backup.sh ] && ! grep -q "${WORK_DIR}/backup.sh" /etc/crontab && echo "${BACKUP_TIME} root bash ${WORK_DIR}/backup.sh a" >> /etc/crontab
    [ -s $WORK_DIR/restore.sh ] && ! grep -q "${WORK_DIR}/restore.sh" /etc/crontab && echo "* * * * * root bash ${WORK_DIR}/restore.sh a" >> /etc/crontab
    service cron restart >/dev/null 2>&1
  fi

  # 璧嬫墽琛屾潈缁?sh 鏂囦欢
  chmod +x ${WORK_DIR}/*.sh

  # 璁板綍璇█
  echo "$L" > ${WORK_DIR}/language

  # 杩愯鍝悞闈㈡澘
  cmd_systemctl enable
  sleep 5

  # 妫€娴嬪苟鏄剧ず缁撴灉
  if [ "$(systemctl is-active nezha-dashboard)" = 'active' ]; then
    [ -n "$ARGO_TOKEN" ] && hint "\n $(text 35) "
    warning "\n $(text 34) " && info "\n $(text 30) $(text 31)! \n"
  else
    error "\n $(text 30) $(text 32)! \n"
  fi
}

# 鍗歌浇
uninstall() {
  cmd_systemctl disable
  grep -q 'REVERSE_PROXY_MODE=nginx' ${WORK_DIR}/run.sh && [ $(ps -ef | grep 'nginx' | wc -l) -le 1 ] && reading " $(text 39) " REMOVE_NGINX
  [[ "$REMOVE_NGINX" = [Yy] ]] && ${PACKAGE_UNINSTALL[int]} nginx
  rm -rf /etc/systemd/system/nezha-dashboard.service ${WORK_DIR}
  if [ "$SYSTEM" = 'Alpine' ]; then
    sed -i "/\/opt\/nezha\/dashboard/d" /var/spool/cron/crontabs/root
  else
    sed -i "/\/opt\/nezha\/dashboard/d" /etc/crontab
    service cron restart >/dev/null 2>&1
  fi
  info "\n $(text 29) $(text 31) "
}

# 鍒ゆ柇褰撳墠 Argo-X 鐨勮繍琛岀姸鎬侊紝骞跺搴旂殑缁欒彍鍗曞拰鍔ㄤ綔璧嬪€?menu_setting() {
  OPTION[0]="0.  $(text 19)"
  ACTION[0]() { exit; }

  if [[ ${STATUS} =~ $(text 27)|$(text 28) ]]; then
    [ ${STATUS} = "$(text 28)" ] && OPTION[1]="1.  $(text 20) " || OPTION[1]="1.  $(text 21) "
    OPTION[2]="2.  $(text 29)"

    [[ ${STATUS} = "$(text 28)" ]] && ACTION[1]() { cmd_systemctl disable; [ "$(systemctl is-active nezha-dashboard)" = 'inactive' ] && info "\n $(text 20) $(text 31) " || error " $(text 20) $(text 32) "; }
    [[ ${STATUS} = "$(text 27)" ]] && ACTION[1]() { cmd_systemctl enable; [ "$(systemctl is-active nezha-dashboard)" = 'active' ] && info "\n $(text 21) $(text 31) " || error "\n $(text 21) $(text 32) "; }

   ACTION[2]() { uninstall; exit; }

  else
    OPTION[1]="1.  $(text 30)"
    OPTION[2]="2.  $(text 37)"

    ACTION[1]() { check_dependencies; install; exit; }
    [ "$L" = 'C' ] && ACTION[2]() { curl -L https://jihulab.com/nezha/dashboard/-/raw/master/script/install.sh -o nezha.sh && chmod +x nezha.sh && CN=true ./nezha.sh; exit; } || ACTION[2]() { curl -L https://raw.githubusercontent.com/naiba/nezha/master/script/install_en.sh  -o nezha.sh && chmod +x nezha.sh && sudo ./nezha.sh; exit; }
  fi
}

menu() {
  clear
  info " $(text 1) "
  echo -e '鈥斺€斺€斺€斺€斺€斺€斺€斺€斺€斺€斺€斺€斺€斺€斺€斺€斺€斺€斺€斺€?\n'
  for ((a=1;a<${#OPTION[*]}; a++)); do hint "\n ${OPTION[a]} "; done
  hint "\n ${OPTION[0]} "
  reading "\n $(text 24) " CHOOSE

  # 杈撳叆蹇呴』鏄暟瀛椾笖灏戜簬绛変簬鏈€澶у彲閫夐」
  if grep -qE "^[0-9]$" <<< "$CHOOSE" && [ "$CHOOSE" -lt "${#OPTION[*]}" ]; then
    ACTION[$CHOOSE]
  else
    warning " $(text 23) [0-$((${#OPTION[*]}-1))] " && sleep 1 && menu
  fi
}

select_language
check_root
check_cdn
check_system_info
check_arch
check_install
menu_setting
menu

