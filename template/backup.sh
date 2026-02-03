#!/usr/bin/env bash

# backup.sh 浼犲弬 a 鑷姩杩樺師锛?浼犲弬 m 鎵嬪姩杩樺師锛?浼犲弬 f 寮哄埗鏇存柊闈㈡澘 app 鏂囦欢鍙?cloudflared 鏂囦欢锛屽苟澶囦唤鏁版嵁鑷虫垚澶囦唤搴撱€?# 濡傛槸 IPv6 only 鎴栬€呭ぇ闄嗘満鍣紝闇€瑕?Github 鍔犻€熺綉锛屽彲鑷鏌ユ壘鏀惧湪 GH_PROXY 澶?锛屽 https://mirror.ghproxy.com/ 锛岃兘涓嶇敤灏变笉鐢紝鍑忓皯鍥犲姞閫熺綉瀵艰嚧鐨勬晠闅溿€?
GH_PROXY=
GH_PAT=
GH_BACKUP_USER=
GH_EMAIL=
GH_REPO=
SYSTEM=
ARCH=
WORK_DIR=
DAYS=5
IS_DOCKER=
DASHBOARD_VERSION=

########

# version: 2024.12.18

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

# 杩愯澶囦唤鑴氭湰鏃讹紝鑷攣涓€瀹氭椂闂翠互闃?Github 缂撳瓨鐨勫師鍥犲鑷存暟鎹┈涓婅杩樺師
touch $(awk -F '=' '/NO_ACTION_FLAG/{print $2; exit}' $WORK_DIR/restore.sh)1

# 鎵嬭嚜鍔ㄦ爣蹇?[ "$1" = 'a' ] && WAY=Scheduled || WAY=Manualed
[ "$1" = 'f' ] && WAY=Manualed && FORCE_UPDATE=true

# 妫€鏌ユ洿鏂伴潰鏉夸富绋嬪簭 app 鍙?cloudflared
if [ -z "$DASHBOARD_VERSION" ]; then
  cd $WORK_DIR
  DASHBOARD_NOW=$(./app -v)
  DASHBOARD_LATEST=$(wget -qO- https://api.github.com/repos/naiba/nezha/releases/latest | awk -F '"' '/tag_name/{print $4}')
  [ "v${DASHBOARD_NOW}" != "$DASHBOARD_LATEST" ] && DASHBOARD_UPDATE=true
elif [[ "$DASHBOARD_VERSION" =~ [0-1]{1}\.[0-9]{1,2}\.[0-9]{1,2}$ ]]; then
  cd $WORK_DIR
  DASHBOARD_NOW=$(./app -v)
  DASHBOARD_LATEST=$(sed 's/v//; s/^/v&/' <<< "$DASHBOARD_VERSION")
  [ "v${DASHBOARD_NOW}" != "$DASHBOARD_LATEST" ] && DASHBOARD_UPDATE=true
else
  error "The DASHBOARD_VERSION variable should be in a format like v0.00.00, please check."
fi

CLOUDFLARED_NOW=$(./cloudflared -v | awk '{for (i=0; i<NF; i++) if ($i=="version") {print $(i+1)}}')
CLOUDFLARED_LATEST=$(wget -qO- https://api.github.com/repos/cloudflare/cloudflared/releases/latest | awk -F '"' '/tag_name/{print $4}')
[[ "$CLOUDFLARED_LATEST" =~ ^20[0-9]{2}\.[0-9]{1,2}\.[0-9]+$ && "$CLOUDFLARED_NOW" != "$CLOUDFLARED_LATEST" ]] && CLOUDFLARED_UPDATE=true

# 妫€娴嬫槸鍚︽湁璁剧疆澶囦唤鏁版嵁
if [[ -n "$GH_REPO" && -n "$GH_BACKUP_USER" && -n "$GH_EMAIL" && -n "$GH_PAT" ]]; then
  IS_PRIVATE="$(wget -qO- --header="Authorization: token $GH_PAT" https://api.github.com/repos/$GH_BACKUP_USER/$GH_REPO | sed -n '/"private":/s/.*:[ ]*\([^,]*\),/\1/gp')"
  if [ "$?" != 0 ]; then
    warning "\n Could not connect to Github. Stop backup. \n"
  elif [ "$IS_PRIVATE" != true ]; then
    warning "\n This is not exist nor a private repository. \n"
  else
    IS_BACKUP=true
  fi
fi

# 鍒嗘楠ゅ鐞?if [[ "${DASHBOARD_UPDATE}${CLOUDFLARED_UPDATE}${IS_BACKUP}${FORCE_UPDATE}" =~ true ]]; then
  # 鏇存柊闈㈡澘涓荤▼搴?  if [[ "${DASHBOARD_UPDATE}${FORCE_UPDATE}" =~ 'true' ]]; then
    hint "\n Renew dashboard app to $DASHBOARD_LATEST \n"
    wget -O /tmp/dashboard.zip ${GH_PROXY}https://github.com/naiba/nezha/releases/download/$DASHBOARD_LATEST/dashboard-linux-$ARCH.zip
    unzip -o /tmp/dashboard.zip -d /tmp
    chmod +x /tmp/dashboard-linux-$ARCH
    if [ -s /tmp/dashboard-linux-$ARCH ]; then
      info "\n Restart Nezha Dashboard \n"
      if [ "$IS_DOCKER" = 1 ]; then
        supervisorctl stop nezha >/dev/null 2>&1
        sleep 10
        mv -f /tmp/dashboard-linux-$ARCH $WORK_DIR/app
        supervisorctl start nezha >/dev/null 2>&1
      else
        cmd_systemctl disable >/dev/null 2>&1
        sleep 10
        mv -f /tmp/dashboard-linux-$ARCH $WORK_DIR/app
        cmd_systemctl enable >/dev/null 2>&1
      fi
    fi
    rm -rf /tmp/dist /tmp/dashboard.zip
  fi

  # 鏇存柊 cloudflared
  if [[ "${CLOUDFLARED_UPDATE}${FORCE_UPDATE}" =~ 'true' ]]; then
    hint "\n Renew Cloudflared to $CLOUDFLARED_LATEST \n"
    wget -O /tmp/cloudflared ${GH_PROXY}https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$ARCH && chmod +x /tmp/cloudflared
    if [ -s /tmp/cloudflared ]; then
      info "\n Restart Argo \n"
      if [ "$IS_DOCKER" = 1 ]; then
        supervisorctl stop argo >/dev/null 2>&1
        mv -f /tmp/cloudflared $WORK_DIR/
        supervisorctl start argo >/dev/null 2>&1
      else
        cmd_systemctl disable >/dev/null 2>&1
        mv -f /tmp/cloudflared $WORK_DIR/
        cmd_systemctl enable >/dev/null 2>&1
      fi
    fi
  fi

  # 鍏嬮殕澶囦唤浠撳簱锛屽帇缂╁浠芥枃浠讹紝涓婁紶鏇存柊
  if [ "$IS_BACKUP" = 'true' ]; then
    # 澶囦唤鍓嶅厛鍋滄帀闈㈡澘锛岃缃?git 鐜鍙橀噺锛屽噺灏戠郴缁熷紑鏀?    if [ "$IS_DOCKER" != 1 ]; then
      cmd_systemctl disable >/dev/null 2>&1
      git config --global core.bigFileThreshold 1k
      git config --global core.compression 0
      git config --global advice.detachedHead false
      git config --global pack.threads 1
      git config --global pack.windowMemory 50m
    else
      supervisorctl stop nezha >/dev/null 2>&1
    fi
    sleep 10

    # 浼樺寲鏁版嵁搴擄紝鎰熻阿 longsays 鐨勮剼鏈?    # 1. 瀵煎嚭鏁版嵁
    sqlite3 "data/sqlite.db" <<EOF
.output /tmp/tmp.sql
.dump
.quit
EOF

    # 2. 瀵煎叆鍒版柊搴?    if [ $? -ne 0 ]; then
      echo "Data export failed!"
    else
      sqlite3 "/tmp/new.sqlite.db" <<EOF
.read /tmp/tmp.sql
.quit
EOF
    fi

    # 3. 妫€鏌ュ鍏ユ槸鍚︽垚鍔?    if [ $? -ne 0 ]; then
      echo "Data import failed!"
    else
      # 瑕嗙洊鍘熷簱骞朵紭鍖?      mv -f "/tmp/new.sqlite.db" "data/sqlite.db"
      sqlite3 "data/sqlite.db" 'VACUUM;'
      [ $? -eq 0 ] && echo "Database migration and optimisation complete!" || echo "Database migration and optimisation failed!"
      # 娓呯悊涓存椂鏂囦欢
      rm -f /tmp/tmp.sql
    fi

    # 鍏嬮殕鐜版湁澶囦唤搴?    [ -d /tmp/$GH_REPO ] && rm -rf /tmp/$GH_REPO
    git clone https://$GH_PAT@github.com/$GH_BACKUP_USER/$GH_REPO.git --depth 1 --quiet /tmp/$GH_REPO

    # 鍘嬬缉澶囦唤鏁版嵁锛屽彧澶囦唤 data/ 鐩綍涓嬬殑 config.yaml 鍜?sqlite.db锛?resource/ 鐩綍涓嬪悕瀛楁湁 custom 鐨勮嚜瀹氫箟涓婚鏂囦欢澶?    if [ -d /tmp/$GH_REPO ]; then
      TIME=$(date "+%Y-%m-%d-%H:%M:%S")
      echo "鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫撯啌 dashboard-$TIME.tar.gz list 鈫撯啌鈫撯啌鈫撯啌鈫撯啌鈫撯啌"
      [ -d "resource" ] && find resource/ -type d -name "*custom*" | tar czvf /tmp/$GH_REPO/dashboard-$TIME.tar.gz -T- data/ || tar czvf /tmp/$GH_REPO/dashboard-$TIME.tar.gz data/
      echo -e "鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫戔啈 dashboard-$TIME.tar.gz list 鈫戔啈鈫戔啈鈫戔啈鈫戔啈鈫戔啈\n\n"

      # 鏇存柊澶囦唤 Github 搴擄紝鍒犻櫎 5 澶╁墠鐨勫浠?      cd /tmp/$GH_REPO
      [ -e ./.git/index.lock ] && rm -f ./.git/index.lock
      echo "dashboard-$TIME.tar.gz" > README.md
      find ./ -name '*.gz' | sort | head -n -$DAYS | xargs rm -f
      git config --global user.name $GH_BACKUP_USER
      git config --global user.email $GH_EMAIL
      git checkout --orphan tmp_work
      git add .
      git commit -m "$WAY at $TIME ."
      git push -f -u origin HEAD:main --quiet
      IS_UPLOAD="$?"
      cd ..
      rm -rf $GH_REPO
      if [ "$IS_UPLOAD" = 0 ]; then
        echo "dashboard-$TIME.tar.gz" > $WORK_DIR/dbfile
        info "\n Succeed to upload the backup files dashboard-$TIME.tar.gz to Github.\n"
      else
        rm -f $(awk -F '=' '/NO_ACTION_FLAG/{print $2; exit}' $WORK_DIR/restore.sh)*
        hint "\n Failed to upload the backup files dashboard-$TIME.tar.gz to Github.\n"
      fi
    fi
  fi
fi

if [ "$IS_DOCKER" = 1 ]; then
  supervisorctl start nezha >/dev/null 2>&1
  [ $(supervisorctl status all | grep -c "RUNNING") = $(grep -c '\[program:.*\]' /etc/supervisor/conf.d/damon.conf) ] && info "\n All programs started! \n" || error "\n Failed to start program! \n"
else
  cmd_systemctl enable >/dev/null 2>&1
  [ "$(systemctl is-active nezha-dashboard)" = 'active' ] && info "\n Nezha dashboard started! \n" || error "\n Failed to start Nezha dashboard! \n"
fi

