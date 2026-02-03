#!/usr/bin/env bash

# 棣栨杩愯鏃舵墽琛屼互涓嬫祦绋嬶紝鍐嶆杩愯鏃跺瓨鍦?/etc/supervisor/conf.d/damon.conf 鏂囦欢锛岀洿鎺ュ埌鏈€鍚庝竴姝?if [ ! -s /etc/supervisor/conf.d/damon.conf ]; then

  # 璁剧疆 Github CDN 鍙婅嫢骞插彉閲忥紝濡傛槸 IPv6 only 鎴栬€呭ぇ闄嗘満鍣紝闇€瑕?Github 鍔犻€熺綉锛屽彲鑷鏌ユ壘鏀惧湪 GH_PROXY 澶?锛屽 https://ghproxy.lvedong.eu.org/ 锛岃兘涓嶇敤灏变笉鐢紝鍑忓皯鍥犲姞閫熺綉瀵艰嚧鐨勬晠闅溿€?  GH_PROXY='https://ghproxy.lvedong.eu.org/'
  GRPC_PROXY_PORT=443
  GRPC_PORT=8008
  WEB_PORT=8080
  PRO_PORT=${PRO_PORT:-'80'}
  BACKUP_TIME=${BACKUP_TIME:-'0 4 * * *'}
  BACKUP_NUM= ${BACKUP_NUM:-'5'}
  CADDY_HTTP_PORT=2052
  WORK_DIR=/dashboard

  # 濡備笉鍒嗙澶囦唤鐨?github 璐︽埛锛岄粯璁や笌鍝悞鐧婚檰鐨?github 璐︽埛涓€鑷?  GH_BACKUP_USER=${GH_BACKUP_USER:-$GH_USER}

  error() { echo -e "\033[31m\033[01m$*\033[0m" && exit 1; } # 绾㈣壊
  info() { echo -e "\033[32m\033[01m$*\033[0m"; }   # 缁胯壊
  hint() { echo -e "\033[33m\033[01m$*\033[0m"; }   # 榛勮壊

  # 濡傚弬鏁颁笉榻愬叏锛屽鍣ㄩ€€鍑猴紝鍙﹀澶勭悊鏌愪簺鐜鍙橀噺濉敊鍚庣殑澶勭悊
  if [[ "$DASHBOARD_VERSION" =~ 0\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
    [[ -z "$GH_USER" || -z "$GH_CLIENTID" || -z "$GH_CLIENTSECRET" || -z "$ARGO_AUTH" || -z "$ARGO_DOMAIN" ]] && error " There are variables that are not set. "
  else
    [[ -z "$ARGO_AUTH" || -z "$ARGO_DOMAIN" ]] && error " There are argo variables that are not set. "
  fi
  [[ "$ARGO_AUTH" =~ TunnelSecret ]] && grep -qv '"' <<< "$ARGO_AUTH" && ARGO_AUTH=$(sed 's@{@{"@g;s@[,:]@"\0"@g;s@}@"}@g' <<< "$ARGO_AUTH")  # Json 鏃讹紝娌℃湁浜?鐨勫鐞?  [[ "$ARGO_AUTH" =~ ey[A-Z0-9a-z=]{120,250}$ ]] && ARGO_AUTH=$(awk '{print $NF}' <<< "$ARGO_AUTH") # Token 澶嶅埗鍏ㄩ儴锛屽彧鍙栨渶鍚庣殑 ey 寮€濮嬬殑
  [ -n "$GH_REPO" ] && grep -q '/' <<< "$GH_REPO" && GH_REPO=$(awk -F '/' '{print $NF}' <<< "$GH_REPO")  # 濉簡椤圭洰鍏ㄨ矾寰勭殑澶勭悊

  # 妫€娴嬫槸鍚﹂渶瑕佸惎鐢?Github CDN锛屽鑳界洿鎺ヨ繛閫氾紝鍒欎笉浣跨敤
  [ -n "$GH_PROXY" ] && wget --server-response --quiet --output-document=/dev/null --no-check-certificate --tries=2 --timeout=3 https://raw.githubusercontent.com/debbide/nezha-argo/main/README.md >/dev/null 2>&1 && unset GH_PROXY

  # 璁剧疆 DNS
  echo -e "nameserver 127.0.0.11\nnameserver 8.8.4.4\nnameserver 223.5.5.5\nnameserver 2001:4860:4860::8844\nnameserver 2400:3200::1\n" > /etc/resolv.conf

  # 璁剧疆 +8 鏃跺尯 (鍖椾含鏃堕棿)
  ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
  dpkg-reconfigure -f noninteractive tzdata

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

  # 鐢ㄦ埛閫夋嫨浣跨敤 gRPC 鍙嶄唬鏂瑰紡: Nginx / Caddy / grpcwebproxy锛岄粯璁や负 Caddy锛涘闇€浣跨敤 grpcwebproxy锛屾妸 REVERSE_PROXY_MODE 鐨勫€艰涓?nginx 鎴?grpcwebproxy
  if [ "$REVERSE_PROXY_MODE" = 'grpcwebproxy' ]; then
    wget -c ${GH_PROXY}https://github.com/fscarmen2/Argo-Nezha-Service-Container/releases/download/grpcwebproxy/grpcwebproxy-linux-$ARCH.tar.gz -qO- | tar xz -C $WORK_DIR
    chmod +x $WORK_DIR/grpcwebproxy
    GRPC_PROXY_RUN="$WORK_DIR/grpcwebproxy --server_tls_cert_file=$WORK_DIR/nezha.pem --server_tls_key_file=$WORK_DIR/nezha.key --server_http_tls_port=$GRPC_PROXY_PORT --backend_addr=localhost:$GRPC_PORT --backend_tls_noverify --server_http_max_read_timeout=300s --server_http_max_write_timeout=300s"
  elif [ "$REVERSE_PROXY_MODE" = 'nginx' ]; then
    GRPC_PROXY_RUN='nginx -g "daemon off;"'
    cat > /etc/nginx/nginx.conf  << EOF
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
  else
    CADDY_LATEST=$(wget -qO- "${GH_PROXY}https://api.github.com/repos/caddyserver/caddy/releases/latest" | awk -F [v\"] '/"tag_name"/{print $5}' || echo '2.7.6')
    wget -c ${GH_PROXY}https://github.com/caddyserver/caddy/releases/download/v${CADDY_LATEST}/caddy_${CADDY_LATEST}_linux_${ARCH}.tar.gz -qO- | tar xz -C $WORK_DIR caddy
    GRPC_PROXY_RUN="$WORK_DIR/caddy run --config $WORK_DIR/Caddyfile --watch"
    cat > $WORK_DIR/Caddyfile  << EOF
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
    if [[ "$DASHBOARD_VERSION" =~ 0\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
      if [ -n "$UUID" ] && [ "$UUID" != "0" ]; then
        cat >> $WORK_DIR/Caddyfile << EOF
:$PRO_PORT {
    reverse_proxy /vls* {
        to localhost:8002
    }

    reverse_proxy /vms* {
        to localhost:8001
    }

    reverse_proxy {
        to localhost:$WEB_PORT
    }
}
EOF
      fi
    else
      if [ -n "$UUID" ] && [ "$UUID" != "0" ]; then
        cat >> $WORK_DIR/Caddyfile << EOF
:$PRO_PORT {
    reverse_proxy /vls* {
        to localhost:8002
    }

    reverse_proxy /vms* {
        to localhost:8001
    }
    
    reverse_proxy {
        to localhost:$GRPC_PORT
    }
}
EOF
      else
        cat >> $WORK_DIR/Caddyfile << EOF
:$PRO_PORT {
    reverse_proxy {
        to localhost:$GRPC_PORT
    }
}
EOF
      fi
    fi
  fi
  
  # 涓嬭浇闇€瑕佺殑搴旂敤
  if [[ -z "$DASHBOARD_VERSION" || "$DASHBOARD_VERSION" =~ 1\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
    if [[ "$DASHBOARD_VERSION" =~ 1\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
      DASHBOARD_LATEST=$(sed 's/v//; s/^/v&/' <<< "$DASHBOARD_VERSION")
      wget -O /tmp/dashboard.zip ${GH_PROXY}https://github.com/naiba/nezha/releases/download/$DASHBOARD_LATEST/dashboard-linux-$ARCH.zip
    else
      wget -O /tmp/dashboard.zip ${GH_PROXY}https://github.com/nezhahq/nezha/releases/latest/download/dashboard-linux-$ARCH.zip
    fi
    if [ -z "$AGENT_VERSION" ]; then
      wget -O $WORK_DIR/nezha-agent.zip ${GH_PROXY}https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_$ARCH.zip
    elif [[ "$AGENT_VERSION" =~ 1\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
      AGENT_LATEST=$(sed 's/v//; s/^/v&/' <<< "$AGENT_VERSION")
      wget -O $WORK_DIR/nezha-agent.zip ${GH_PROXY}https://github.com/nezhahq/agent/releases/download/$AGENT_LATEST/nezha-agent_linux_$ARCH.zip
    else
      error "The AGENT_VERSION variable is not in the correct format, please check."
    fi
  elif [[ "$DASHBOARD_VERSION" =~ 0\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
    [-z "$GH_USER" || -z "$GH_CLIENTID" || -z "$GH_CLIENTSECRET"] && error " There are github variables that are not set. "
    DASHBOARD_LATEST=$(sed 's/v//; s/^/v&/' <<< "$DASHBOARD_VERSION")
    wget -O /tmp/dashboard.zip ${GH_PROXY}https://github.com/naiba/nezha/releases/download/$DASHBOARD_LATEST/dashboard-linux-$ARCH.zip
    if [ -z "$AGENT_VERSION" ]; then
      wget -O $WORK_DIR/nezha-agent.zip ${GH_PROXY}https://github.com/nezhahq/agent/releases/download/v0.20.5/nezha-agent_linux_$ARCH.zip
    elif [[ "$AGENT_VERSION" =~ 0\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
      AGENT_LATEST=$(sed 's/v//; s/^/v&/' <<< "$AGENT_VERSION")
      wget -O $WORK_DIR/nezha-agent.zip ${GH_PROXY}https://github.com/nezhahq/agent/releases/download/$AGENT_LATEST/nezha-agent_linux_$ARCH.zip
    else
      error "The AGENT_VERSION variable is not in the correct format, please check."
    fi
  else
    error "The DASHBOARD_VERSION variable is not in the correct format, please check."
  fi
  unzip -o /tmp/dashboard.zip -d /tmp
  [ -d /tmp/dist ] && mv /tmp/dist/dashboard-linux-$ARCH /tmp/dashboard-linux-$ARCH
  chmod +x /tmp/dashboard-linux-$ARCH
  mv -f /tmp/dashboard-linux-$ARCH $WORK_DIR/app
  wget -qO $WORK_DIR/cloudflared ${GH_PROXY}https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$ARCH
  unzip -o $WORK_DIR/nezha-agent.zip -d $WORK_DIR/
  rm -rf $WORK_DIR/nezha-agent.zip /tmp/dist /tmp/dashboard.zip

  # 鏍规嵁鍙傛暟鐢熸垚鍝悞鏈嶅姟绔厤缃枃浠?  [ ! -d data ] && mkdir data
  if [[ "$DASHBOARD_VERSION" =~ 0\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
    cat > ${WORK_DIR}/data/config.yaml << EOF
Debug: false
HTTPPort: $WEB_PORT
Language: zh-CN
GRPCPort: $GRPC_PORT
GRPCHost: $ARGO_DOMAIN
ProxyGRPCPort: $GRPC_PROXY_PORT
TLS: true
Oauth2:
  Type: "github" #Oauth2 鐧诲綍鎺ュ叆绫诲瀷锛実ithub/gitlab/jihulab/gitee/gitea ## Argo-瀹瑰櫒鐗堟湰鍙敮鎸?github
  Admin: "$GH_USER" #绠＄悊鍛樺垪琛紝鍗婅閫楀彿闅斿紑
  ClientID: "$GH_CLIENTID" # 鍦?${GH_PROXY}https://github.com/settings/developers 鍒涘缓锛屾棤闇€瀹℃牳 Callback 濉?http(s)://鍩熷悕鎴朓P/oauth2/callback
  ClientSecret: "$GH_CLIENTSECRET"
  Endpoint: "" # 濡俫itea鑷缓闇€瑕佽缃?## Argo-瀹瑰櫒鐗堟湰鍙敮鎸?github
site:
  Brand: "Nezha Probe"
  Cookiename: "nezha-dashboard" #娴忚鍣?Cookie 瀛楁鍚嶏紝鍙笉鏀?  Theme: "default"
EOF
  else
    LOCAL_TOKEN=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 32)
    AGENT_UUID=$(openssl rand -hex 16 | sed 's/\(........\)\(....\)\(....\)\(....\)\(............\)/\1-\2-\3-\4-\5/')
    cat > ${WORK_DIR}/data/config.yaml << EOF
agent_secret_key: $LOCAL_TOKEN
debug: false
listen_port: $GRPC_PORT
language: zh-CN
site_name: "Nezha Probe"
install_host: $ARGO_DOMAIN:$GRPC_PROXY_PORT
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
    cat > ${WORK_DIR}/data/config.yml << EOF
client_secret: $LOCAL_TOKEN
debug: false
disable_command_execute: false
disable_nat: false
disable_send_query: false
gpu: false
insecure_tls: true
ip_report_period: 1800
report_delay: 3
server: $ARGO_DOMAIN:$GRPC_PROXY_PORT
skip_connection_count: false
skip_procs_count: false
temperature: false
tls: true
use_gitee_to_upgrade: false
use_ipv6_country_code: false
uuid: $AGENT_UUID
EOF
    if [ -z "$AGENT_VERSION" ]; then
      cat >> ${WORK_DIR}/data/config.yml << EOF
disable_auto_update: false
disable_force_update: false
EOF
    else
      cat >> ${WORK_DIR}/data/config.yml << EOF
disable_auto_update: true
disable_force_update: true
EOF
    fi
  fi

  if [[ "$DASHBOARD_VERSION" =~ 0\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
    # 涓嬭浇鍖呭惈鏈湴鏁版嵁鐨?sqlite.db 鏂囦欢锛岀敓鎴?8浣嶉殢鏈哄瓧绗︿覆鐢ㄤ簬鏈湴 Token
    wget -P ${WORK_DIR}/data/ ${GH_PROXY}https://github.com/debbide/nezha-argo/raw/main/sqlite.db
    LOCAL_TOKEN=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 18)
    sqlite3 ${WORK_DIR}/data/sqlite.db "update servers set secret='${LOCAL_TOKEN}' where created_at='2023-04-23 13:02:00.770756566+08:00'"
  fi

  if [[ -n "$GH_CLIENTID" && -n "$GH_CLIENTSECRET" ]]; then
    # SSH path 涓?GH_CLIENTID 涓€鏍?    echo root:"$GH_CLIENTSECRET" | chpasswd root
    sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/g;s/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    service ssh restart
  fi

  # 鍒ゆ柇 ARGO_AUTH 涓?json 杩樻槸 token
  # 濡備负 json 灏嗙敓鎴?argo.json 鍜?argo.yml 鏂囦欢
  if [[ "$ARGO_AUTH" =~ TunnelSecret ]]; then
    ARGO_RUN="cloudflared tunnel --edge-ip-version auto --config $WORK_DIR/argo.yml run"

    echo "$ARGO_AUTH" > $WORK_DIR/argo.json

    cat > $WORK_DIR/argo.yml << EOF
tunnel: $(cut -d '"' -f12 <<< "$ARGO_AUTH")
credentials-file: $WORK_DIR/argo.json
protocol: http2

ingress:
  - hostname: $ARGO_DOMAIN
    service: https://localhost:$GRPC_PROXY_PORT
    path: /proto.NezhaService/*
    originRequest:
      http2Origin: true
      noTLSVerify: true
  - hostname: $ARGO_DOMAIN
    service: ssh://localhost:22
    path: /$GH_CLIENTID/*
  - hostname: $ARGO_DOMAIN
EOF
    if [[ "$DASHBOARD_VERSION" =~ 0\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
      cat >> $WORK_DIR/argo.yml << EOF
    service: http://localhost:$WEB_PORT
  - service: http_status:404
EOF
    else
      cat >> $WORK_DIR/argo.yml << EOF
    service: http://localhost:$PRO_PORT
  - service: http_status:404
EOF
    fi
  # 濡備负 token 鏃?  elif [[ "$ARGO_AUTH" =~ ^ey[A-Z0-9a-z=]{120,250}$ ]]; then
    ARGO_RUN="cloudflared tunnel --edge-ip-version auto --protocol http2 run --token ${ARGO_AUTH}"
  fi

  # 鐢熸垚鑷缃睸SL璇佷功
  openssl genrsa -out $WORK_DIR/nezha.key 2048
  openssl req -new -subj "/CN=$ARGO_DOMAIN" -key $WORK_DIR/nezha.key -out $WORK_DIR/nezha.csr
  openssl x509 -req -days 36500 -in $WORK_DIR/nezha.csr -signkey $WORK_DIR/nezha.key -out $WORK_DIR/nezha.pem

  # 鐢熸垚 backup.sh 鏂囦欢鐨勬楠? - 璁剧疆鐜鍙橀噺
  cat > $WORK_DIR/backup.sh << EOF
#!/usr/bin/env bash

# backup.sh 浼犲弬 a 鑷姩杩樺師锛?浼犲弬 m 鎵嬪姩杩樺師锛?浼犲弬 f 寮哄埗鏇存柊闈㈡澘 app 鏂囦欢鍙?cloudflared 鏂囦欢锛屽苟澶囦唤鏁版嵁鑷虫垚澶囦唤搴?
GH_PROXY=$GH_PROXY
GH_PAT=$GH_PAT
GH_BACKUP_USER=$GH_BACKUP_USER
GH_EMAIL=$GH_EMAIL
GH_REPO=$GH_REPO
ARCH=$ARCH
WORK_DIR=$WORK_DIR
DAYS=$BACKUP_NUM
IS_DOCKER=1
DASHBOARD_VERSION=$DASHBOARD_VERSION

########
EOF

  # 鐢熸垚 backup.sh 鏂囦欢鐨勬楠? - 鍦ㄧ嚎鑾峰彇 template/bakcup.sh 妯℃澘鐢熸垚瀹屾暣 backup.sh 鏂囦欢
  wget -qO- ${GH_PROXY}https://raw.githubusercontent.com/debbide/nezha-argo/main/template/backup.sh | sed '1,/^########/d' >> $WORK_DIR/backup.sh

  if [[ -n "$GH_BACKUP_USER" && -n "$GH_EMAIL" && -n "$GH_REPO" && -n "$GH_PAT" ]]; then
    # 鐢熸垚 restore.sh 鏂囦欢鐨勬楠? - 璁剧疆鐜鍙橀噺
    cat > $WORK_DIR/restore.sh << EOF
#!/usr/bin/env bash

# restore.sh 浼犲弬 a 鑷姩杩樺師 README.md 璁板綍鐨勬枃浠讹紝褰撴湰鍦颁笌杩滅▼璁板綍鏂囦欢涓€鏍锋椂涓嶈繕鍘燂紱 浼犲弬 f 涓嶇鏈湴璁板綍鏂囦欢锛屽己鍒惰繕鍘熸垚澶囦唤搴撻噷 README.md 璁板綍鐨勬枃浠讹紱 浼犲弬 dashboard-***.tar.gz 杩樺師鎴愬浠藉簱閲岀殑璇ユ枃浠讹紱涓嶅甫鍙傛暟鍒欒姹傞€夋嫨澶囦唤搴撻噷鐨勬枃浠跺悕

GH_PROXY=$GH_PROXY
GH_PAT=$GH_PAT
GH_BACKUP_USER=$GH_BACKUP_USER
GH_REPO=$GH_REPO
WORK_DIR=$WORK_DIR
TEMP_DIR=/tmp/restore_temp
NO_ACTION_FLAG=/tmp/flag
IS_DOCKER=1

########
EOF

    # 鐢熸垚 restore.sh 鏂囦欢鐨勬楠? - 鍦ㄧ嚎鑾峰彇 template/restore.sh 妯℃澘鐢熸垚瀹屾暣 restore.sh 鏂囦欢
    wget -qO- ${GH_PROXY}https://raw.githubusercontent.com/debbide/nezha-argo/main/template/restore.sh | sed '1,/^########/d' >> $WORK_DIR/restore.sh
  fi

  # 鐢熸垚 renew.sh 鏂囦欢鐨勬楠? - 璁剧疆鐜鍙橀噺
  cat > $WORK_DIR/renew.sh << EOF
#!/usr/bin/env bash

GH_PROXY=$GH_PROXY
WORK_DIR=/dashboard
TEMP_DIR=/tmp/renew

########
EOF

  # 鐢熸垚 renew.sh 鏂囦欢鐨勬楠? - 鍦ㄧ嚎鑾峰彇 template/renew.sh 妯℃澘鐢熸垚瀹屾暣 renew.sh 鏂囦欢
  wget -qO- ${GH_PROXY}https://raw.githubusercontent.com/debbide/nezha-argo/main/template/renew.sh | sed '1,/^########/d' >> $WORK_DIR/renew.sh

  # 鐢熸垚瀹氭椂浠诲姟: 1.姣忓ぉ鍖椾含鏃堕棿 3:30:00 鏇存柊澶囦唤鍜岃繕鍘熸枃浠讹紝2.姣忓ぉ鍖椾含鏃堕棿 4:00:00 澶囦唤涓€娆★紝骞堕噸鍚?cron 鏈嶅姟锛?3.姣忓垎閽熻嚜鍔ㄦ娴嬪湪绾垮浠芥枃浠堕噷鐨勫唴瀹?  [ -z "$NO_AUTO_RENEW" ] && [ -s $WORK_DIR/renew.sh ] && ! grep -q "$WORK_DIR/renew.sh" /etc/crontab && echo "30 3 * * * root bash $WORK_DIR/renew.sh" >> /etc/crontab
  [ -s $WORK_DIR/backup.sh ] && ! grep -q "$WORK_DIR/backup.sh" /etc/crontab && echo "$BACKUP_TIME root bash $WORK_DIR/backup.sh a" >> /etc/crontab
  [ -s $WORK_DIR/restore.sh ] && ! grep -q "$WORK_DIR/restore.sh" /etc/crontab && echo "* * * * * root bash $WORK_DIR/restore.sh a" >> /etc/crontab
  service cron restart

if [ -n "$UUID" ] && [ "$UUID" != "0" ]; then
  # 鍚姩xxxry
  wget -qO- https://github.com/dsadsadsss/d/releases/download/sd/kano-6-amd-w > $WORK_DIR/webapp
  chmod 777 $WORK_DIR/webapp
  WEB_RUN="$WORK_DIR/webapp"
fi
if [[ "$DASHBOARD_VERSION" =~ 0\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
   AG_RUN="$WORK_DIR/nezha-agent -s localhost:$GRPC_PORT -p $LOCAL_TOKEN --disable-auto-update --disable-force-update"
else
   AG_RUN="$WORK_DIR/nezha-agent -c $WORK_DIR/data/config.yml"
fi
  # 鐢熸垚 supervisor 杩涚▼瀹堟姢閰嶇疆鏂囦欢
  cat > /etc/supervisor/conf.d/damon.conf << EOF
[supervisord]
nodaemon=true
logfile=/dev/null
pidfile=/run/supervisord.pid

[program:grpcproxy]
command=$GRPC_PROXY_RUN
autostart=true
autorestart=true
stderr_logfile=/dev/null
stdout_logfile=/dev/null

[program:nezha]
command=$WORK_DIR/app
autostart=true
autorestart=true
stderr_logfile=/dev/null
stdout_logfile=/dev/null

[program:agent]
command=$AG_RUN
autostart=true
autorestart=true
stderr_logfile=/dev/null
stdout_logfile=/dev/null

[program:argo]
command=$WORK_DIR/$ARGO_RUN
autostart=true
autorestart=true
stderr_logfile=/dev/null
stdout_logfile=/dev/null
EOF
if [ -n "$UUID" ] && [ "$UUID" != "0" ]; then
    cat >> /etc/supervisor/conf.d/damon.conf << EOF

[program:webapp]
command=$WEB_RUN
autostart=true
autorestart=true
stderr_logfile=/dev/null
stdout_logfile=/dev/null
EOF
get_country_code() {
    country_code="UN"
    urls=("http://ipinfo.io/country" "https://ifconfig.co/country" "https://ipapi.co/country")

    for url in "${urls[@]}"; do
        if [ "$download_tool" = "curl" ]; then
            country_code=$(curl -s "$url")
        else
            country_code=$(wget -qO- "$url")
        fi

        if [ -n "$country_code" ] && [ ${#country_code} -eq 2 ]; then
            break
        fi
    done

    echo "     鍥藉:    $country_code"
}
get_country_code
XIEYI='vl'
XIEYI2='vm'
CF_IP=${CF_IP:-'ip.sb'}
SUB_NAME=${SUB_NAME:-'nezha'}
up_url="${XIEYI}ess://${UUID}@${CF_IP}:443?path=%2F${XIEYI}s%3Fed%3D2048&security=tls&encryption=none&host=${ARGO_DOMAIN}&type=ws&sni=${ARGO_DOMAIN}#${country_code}-${SUB_NAME}-${XIEYI}"
VM_SS="{ \"v\": \"2\", \"ps\": \"${country_code}-${SUB_NAME}-${XIEYI2}\", \"add\": \"${CF_IP}\", \"port\": \"443\", \"id\": \"${UUID}\", \"aid\": \"0\", \"scy\": \"none\", \"net\": \"ws\", \"type\": \"none\", \"host\": \"${ARGO_DOMAIN}\", \"path\": \"/vms?ed=2048\", \"tls\": \"tls\", \"sni\": \"${ARGO_DOMAIN}\", \"alpn\": \"\", \"fp\": \"randomized\", \"allowlnsecure\": \"flase\"}"
if command -v base64 >/dev/null 2>&1; then
  vm_url="${XIEYI2}ess://$(echo -n "$VM_SS" | base64 -w 0)"
fi
x_url="${up_url}\n${vm_url}"
encoded_url=$(echo -e "${x_url}\n${up_url2}" | base64 -w 0)
echo "============  <鑺傜偣淇℃伅:>  ========  "
echo "  "
echo "$encoded_url"
echo "  "
echo "=============================="
fi
  # 璧嬫墽琛屾潈缁?sh 鍙婃墍鏈夊簲鐢?  chmod +x $WORK_DIR/{cloudflared,app,nezha-agent,*.sh}

fi

# 杩愯 supervisor 杩涚▼瀹堟姢
supervisord -c /etc/supervisor/supervisord.conf

