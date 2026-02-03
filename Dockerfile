FROM debian

WORKDIR /dashboard

RUN apt-get update &&\
    apt-get -y install openssh-server wget iproute2 vim git cron unzip supervisor nginx sqlite3 &&\
    git config --global core.bigFileThreshold 1k &&\
    git config --global core.compression 0 &&\
    git config --global advice.detachedHead false &&\
    git config --global pack.threads 1 &&\
    git config --global pack.windowMemory 50m &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

# 将本地修复好的脚本和依赖复制进镜像
COPY init.sh /dashboard/init.sh
COPY . /dashboard/

RUN chmod +x /dashboard/init.sh

ENTRYPOINT ["/dashboard/init.sh"]