# Argo-Nezha-Service-Container 兼容 v0 �?v1

- 本项�?*兼容了nezha的v0和v1版本**，基于fscarmen大佬�?[Argo-Nezha-Service-Container](https://github.com/fscarmen2/Argo-Nezha-Service-Container) 修改�?
- docker版本还结合了dsadsadsss大佬�?[Docker-for-Nezha-Argo-server-v0.x](https://github.com/dsadsadsss/Docker-for-Nezha-Argo-server-v0.x) �?
- 使用前，**请先阅读 [F佬原项目教程](https://github.com/debbide/nezha-argo#f%E4%BD%AC%E5%8E%9F%E9%A1%B9%E7%9B%AE%E6%95%99%E7%A8%8B)** ，了解具体如何部署，本项目仅在一些变量上有所不同�?
<details>
  <summary>更新日志</summary>

- 2025.11.4
  - 修复v1面板的固定版本问题�?  - 测试vps脚本并完成�?- 2025.07.14
  - 增加了`AGENT_VERSION`变量以控制探针版本�?  - docker版本目前已很完善，不出意外以后将佛系更新（其实nezha官方也已步入稳定周期）�?- 2025.07.01
  - 增加了`BACKUP_NUM`变量以控制备份仓库内的备份总数，默认为5�?- 2025.04.28
  - 修复了argo json配置未适配v1面板的问题�?- 2025.04.20
  - 更新了README.md�?- 2025.04.14
  - 经过4天的测试，argo-nezha兼容v0和v1版本可以正常使用�?</details>

## 部署前的准备工作
- 域名准备
  - �?`cf` 官网上找到使用域名的 `网络` 选项，将 `gRPC` 开关打开
  - 获取 `argo` 认证，[点击前往教程](https://github.com/debbide/nezha-argo/blob/main/README.md#argo-%E8%AE%A4%E8%AF%81%E7%9A%84%E8%8E%B7%E5%8F%96%E6%96%B9%E5%BC%8F-json-%E6%88%96-token)
- github账号准备
  - 获得 `github` �?`OAuth 2.0` 认证�?`PAT` ,[点击前往教程](https://github.com/debbide/nezha-argo/blob/main/README.md#%E5%87%86%E5%A4%87%E9%9C%80%E8%A6%81%E7%94%A8%E7%9A%84%E5%8F%98%E9%87%8F)，注�?`v0` �?`v1` �?`OAuth 2.0` 认证是不同的，[点击前往了解区别](https://github.com/debbide/nezha-argo#%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98%E4%BB%A5%E5%8F%8A%E5%9D%91%E7%82%B9)�?## docker镜像及其环境变量说明

docker镜像�?`mikehand888/argo-nezha:latest` �?支持 amd64 �?arm64 架构�?
[容器平台上部署教程，点击前往](https://github.com/debbide/nezha-argo/blob/main/README.md#paas-%E9%83%A8%E7%BD%B2%E5%AE%9E%E4%BE%8B)

[VPS上docker部署教程，点击前往](https://github.com/debbide/nezha-argo/blob/main/README.md#vps-%E9%83%A8%E7%BD%B2%E6%96%B9%E5%BC%8F-1-----docker)


  | 变量�?       | 是否必须  | 备注 |
  | ------------ | ------   | ---- |
  | GH_USER             | v0必填 | github 的用户名，用于面板管理授�?|
  | GH_CLIENTID         | v0必填 | �?github 上申�?|
  | GH_CLIENTSECRET     | v0必填 | �?github 上申�?|
  | GH_BACKUP_USER      | 备份或填 | �?github 上备份哪吒服务端数据库的 github 用户名，不填则与面板管理授权的账�?GH_USER 一�? |
  | GH_REPO             | 备份必填 | �?github 上备份哪吒服务端数据库文件的 github �?|
  | GH_EMAIL            | 备份必填 | github 的邮箱，用于备份库的 git 推�?|
  | GH_PAT              | 备份必填 | github 的私钥（PAT），用于备份库的 git 推�?|
  | REVERSE_PROXY_MODE  | �?| 默认使用 Caddy 应用来反代，可以不填。v0可�?Nginx �?gRPCwebProxy；v1必须�?Caddy |
  | ARGO_AUTH           | 必填 | Json: �?https://fscarmen.cloudflare.now.cc 获取�?Argo Json<br> Token: �?Cloudflare 官网获取 |
  | ARGO_DOMAIN         | 必填 | Argo 域名 |
  | NO_AUTO_RENEW       | �?| 默认不需要该变量，即每天定时同步在线最新的备份和还原脚本。如不需要该功能，设置此变量�?`1` |
  | DASHBOARD_VERSION   | �?| 指定面板的版本。`v0.00.00` 的格式和 `v1.00.00` 的格式，填写了将会把版本固定在所填版本。不填则是最新的v1面板 |
  | AGENT_VERSION       | �?| 指定探针的版本。`v0.00.00` 的格式和 `v1.00.00` 的格式，填写了将会把版本固定在所填版本。不填有两种情况：对于v1面板是保持最新的v1探针；对于v0面板是v0.20.5版本 |
  | PRO_PORT            | �?| 容器平台的开放端口，不填默认�?0。如果容器开放的端口不为80且argo隧道使用的token，则修改此处并手动修改隧道设置里对应的端�?|
  | UUID                | �?| 填写会有节点，在日志查看base64 |
  | BACKUP_TIME         | �?| 自定义备份时间，不填默认�?`0 4 * * *`，即每天北京时间4点备�?|
  | BACKUP_NUM          | �?| 自定义备份仓库中的备份总数，不填默认为 5，即仓库里只保留5个备�?|

## 在VPS上使用脚本部�?
```
bash <(wget -qO- https://raw.githubusercontent.com/debbide/nezha-argo/main/dashboard.sh)
```
跟随脚本步骤即可部署完成

## 常见问题、坑�?  | 常见问题       | 注意内容  |
  | ------------ | ------   |
  | 探针不上线，[点击前往域名准备教程](https://github.com/debbide/nezha-argo#%E5%87%86%E5%A4%87%E9%9C%80%E8%A6%81%E7%94%A8%E7%9A%84%E5%8F%98%E9%87%8F) | 请在 `cf` 面板查看 `argo`域名�?`grpc` 设置，一定要开启！还有可能是域名的问题，可以换个域名试�?|
  | agent的安装命�?| 端口需确认�?`443` ，`tls` 需确认�?`true` |
  | OAuth 2.0 | v0�?`https://你的面板域名/oauth2/callback`，v1�?`https://你的面板域名/api/v1/oauth2/callback` |
  | 使用备份，[点击前往备份教程](https://github.com/debbide/nezha-argo?tab=readme-ov-file#%E6%89%8B%E5%8A%A8%E5%A4%87%E4%BB%BD%E6%95%B0%E6%8D%AE) | 有的容器重启会丢失数据，需要使用备份，需�?`GH_USER`或`GH_BACKUP_USER`、`GH_REPO`、`GH_EMAIL`、`GH_PAT` �?个变量有�?|
  | 注意自动还原 | 容器在修改环境变量后会重新部署，注意备份库会自动还原备份 |
  | 使用本地ssh，[点击前往ssh教程](https://github.com/debbide/nezha-argo?tab=readme-ov-file#ssh-%E6%8E%A5%E5%85%A5) | 需�?`GH_CLIENTID`、`GH_CLIENTSECRET` �?个变量有�?|

* * *
<br>
<br>
<br>

# F佬原项目教程

使用 Argo 隧道的哪吒服务端

Documentation: [English version](https://github.com/fscarmen2/Argo-Nezha-Service-Container/blob/main/README_EN.md) | 中文�?
* * *

# 目录

- [项目特点](README.md#项目特点)
- [准备需要用的变量](README.md#准备需要用的变�?
- [Argo 认证的获取方�? json �?token](README.md#argo-认证的获取方�?json-�?token)
- [PaaS 部署实例](README.md#PaaS-部署实例)
- [VPS 部署方式 1 --- docker](README.md#vps-部署方式-1-----docker)
- [VPS 部署方式 2 --- 宿主机](README.md#vps-部署方式-2-----宿主�?
- [客户端接入](README.md#客户端接�?
- [SSH 接入](README.md#ssh-接入)
- [手动备份数据](README.md#手动备份数据)
- [手动更新备份和还原脚本](README.md#手动更新备份和还原脚�?
- [自动还原备份](README.md#自动还原备份)
- [手动还原备份](README.md#手动还原备份)
- [完美搬家](README.md#完美搬家)
- [主体目录文件及说明](README.md#主体目录文件及说�?
- [鸣谢下列作者的文章和项目](README.md#鸣谢下列作者的文章和项�?
- [免责声明](README.md#免责声明)

* * *

## 项目特点:
* 适用范围更广 --- 只要能连通网络，就能安装哪吒服务端，�?LXC, OpenVZ VPS，Nas 虚拟�?, Container PaaS �?* Argo 隧道突破需要公网入口的限制 --- 传统的哪吒需要有两个公网端口，一个用于面板的访问，另一个用于客户端上报数据，本项目借用 Cloudflare Argo 隧道，使用内网穿透的办法
* IPv4 / v6 具备更高的灵活�?--- 传统哪吒需要处理服务端和客户端�?IPv4/v6 兼容性问题，还需要通过 warp 等工具来解决不对应的情况。然而，本项目可以完全不需要考虑这些问题，可以任意对接，更加方便和简�?* 一�?Argo 隧道分流多个域名和协�?--- 建立一条内网穿透的 Argo 隧道，即可分流三个域�?hostname)和协�?protocal)，分别用于面板的访问(http)，客户端上报数据(tcp)�?ssh（可选）
* Grpc 反向代理�?gRPC 数据端口 --- 配上证书�?tls 终结，然�?Argo 的隧道配置用 https 服务指向这个反向代理，启用http2回源，grpc(nezha)->Grpc Proxy->h2(argo)->cf cdn edge->agent
* 每天自动备份 --- 数据持久化从本地改为线上，北京时间每�?4 �?0 分自动备份整个哪吒面板文件夹到指定的 github 私库，包括面板主题，面板设置，探针数据和隧道信息，备份保留近 5 天数据；鉴于内容十分重要，必须要放在私库
* 每天自动更新面板和更新脚�?-- 北京时间每天 4 �?0 分自动检测最新的官方面板版本及备份还原脚本，有升级时自动更新
* 每天自动优化 SQLite 数据�?--- 北京时间每天 4 �?0 分自动使�?`sqlite3 "sqlite.db" 'VACUUM;'` 优化瘦身数据�?* �?自一体还原备�?--- 每分钟检测一次在线还原文件的内容，遇到有更新立刻还原
* 默认内置本机探针 --- 能很方便的监控自身服务器信息

<img width="1609" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/ecd9d887-68f0-46f9-9a63-eb0275f066eb">


## 准备需要用的变�?* �?Cloudflare 官网，选择使用的域名，打开 `网络` 选项�?`gRPC` 开关打开

<img width="1590" alt="image" src="https://user-images.githubusercontent.com/92626977/233138703-faab8596-a64a-40bb-afe6-52711489fbcf.png">

* 获取 github 认证授权: https://github.com/settings/applications/new

面板域名加上 `https://` 开头，回调地址再加�?`/oauth2/callback` 结尾

<img width="916" alt="image" src="https://user-images.githubusercontent.com/92626977/231099071-b6676f2f-6c7b-4e2f-8411-c134143cab24.png">
<img width="1122" alt="image" src="https://user-images.githubusercontent.com/92626977/231086319-1b625dc6-713b-4a62-80b1-cc5b2b7ef3ca.png">

* 获取 github �?PAT (Personal Access Token): https://github.com/settings/tokens/new

<img width="1226" alt="image" src="https://user-images.githubusercontent.com/92626977/233346036-60819f98-c89a-4cef-b134-0d47c5cc333d.png">
<img width="1148" alt="image" src="https://user-images.githubusercontent.com/92626977/233346508-273c422e-05c3-4c91-9fae-438202364787.png">

* 创建 github 用于备份的私�? https://github.com/new

<img width="814" alt="image" src="https://user-images.githubusercontent.com/92626977/233345537-c5b9dc27-35c4-407b-8809-b0ef68d9ad55.png">


## Argo 认证的获取方�? json �?token
Argo 隧道认证方式�?json �?token，使用两个方式其中之一。推荐前者，理由脚本会处理好所有的 Argo 隧道参数和路径，后者需要到 Cloudflare 官网手动设置，容易出错�?
### (方式 1 - Json):
#### 通过 Cloudflare Json 生成网轻松获�?Argo 隧道 json 信息: https://fscarmen.cloudflare.now.cc

<img width="893" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/5b734a9d-b4fd-40ca-b7e6-5a1732a53175">

### (方式 2 - Token): 通过 Cloudflare 官网，手动生�?Argo 隧道 token 信息
#### �?cf 官网：https://dash.cloudflare.com/
* 进入 zero trust 里生�?token 隧道和信息�?* 其中数据路径 443/https �?`proto.NezhaService`
* ssh 路径 22/ssh �?< client id >

<img width="1672" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/0c467d8b-5fbc-4bde-ac8a-db70ed8798f0">
<img width="1659" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/5aa4df19-f277-4582-8a4d-eef34a00085c">
<img width="1470" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/ec06ec20-a68d-405c-b6de-cd4c52cbd8c0">
<img width="1342" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/538707e1-a17b-4a0f-a8c0-63d0c7bc96aa">
<img width="1020" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/9f5778fd-aa94-4fda-9d85-552b68f6d530">
<img width="1652" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/d0fba15c-f41b-4ee4-bea3-f0506d9b2d23">
<img width="1410" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/228b8e86-32a8-479a-8a86-89ed9b8b5b5e">


## PaaS 部署实例
镜像 `fscarmen/argo-nezha:latest` �?支持 amd64 �?arm64 架构

用到的变�?  | 变量�?       | 是否必须  | 备注 |
  | ------------ | ------   | ---- |
  | GH_USER             | �?| github 的用户名，用于面板管理授�?|
  | GH_CLIENTID         | �?| �?github 上申�?|
  | GH_CLIENTSECRET     | �?| �?github 上申�?|
  | GH_BACKUP_USER      | �?| �?github 上备份哪吒服务端数据库的 github 用户名，不填则与面板管理授权的账�?GH_USER 一�? |
  | GH_REPO             | �?| �?github 上备份哪吒服务端数据库文件的 github �?|
  | GH_EMAIL            | �?| github 的邮箱，用于备份�?git 推送到远程�?|
  | GH_PAT              | �?| github �?PAT |
  | REVERSE_PROXY_MODE  | �?| 默认使用 Caddy 应用来反代，这时可以不填写该变量；如需 Nginx �?gRPCwebProxy 反代，请设置该值为 `nginx ` �?`grpcwebproxy` |
  | ARGO_AUTH           | �?| Json: �?https://fscarmen.cloudflare.now.cc 获取�?Argo Json<br> Token: �?Cloudflare 官网获取 |
  | ARGO_DOMAIN         | �?| Argo 域名 |
  | NO_AUTO_RENEW       | �?| 默认不需要该变量，即每天定时同步在线最新的备份和还原脚本。如不需要该功能，设置此变量，并赋值为 `1` |
  | DASHBOARD_VERSION   | �?| 指定面板的版本，�?`v0.00.00` 的格式，后续将固定在该版本不会升级，不填则使用默认的 `v0.20.13` |

Koyeb

[![Deploy to Koyeb](https://www.koyeb.com/static/images/deploy/button.svg)](https://app.koyeb.com/deploy?type=docker&name=nezha&ports=80;http;/&env[GH_USER]=&env[GH_CLIENTID]=&env[GH_CLIENTSECRET]=&env[GH_REPO]=&env[GH_EMAIL]=&env[GH_PAT]=&env[ARGO_AUTH]=&env[ARGO_DOMAIN]=&image=docker.io/fscarmen/argo-nezha)

<img width="927" alt="image" src="https://user-images.githubusercontent.com/92626977/231088411-fbac3e6e-a8a6-4661-bcf8-7c777aa8ffeb.png">
<img width="750" alt="image" src="https://user-images.githubusercontent.com/92626977/231088973-7134aefd-4c80-4559-8e40-17c3be11d27d.png">
<img width="877" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/8cfdb9ab-5fb6-483f-a382-47aef0d64bea">
<img width="1187" alt="image" src="https://user-images.githubusercontent.com/92626977/231092893-c8f017a2-ee0e-4e28-bee3-7343158f0fa7.png">
<img width="500" alt="image" src="https://user-images.githubusercontent.com/92626977/231094144-df6715bc-c611-47ce-a529-03c43f38102e.png">


## VPS 部署方式 1 --- docker
* 注意: ARGO_DOMAIN= 后面需要有单引号，不能去掉
* 如果 VPS �?IPv6 only 的，请先安装 WARP IPv4 或者双�? https://gitlab.com/fscarmen/warp
* 备份目录为当前路径的 dashboard 文件�?
### docker 部署

```
docker run -dit \
           --name nezha_dashboard \
           --pull always \
           --restart always \
           -e GH_USER=<�?github 用户�? \
           -e GH_EMAIL=<�?github 邮箱> \
           -e GH_PAT=<填获取的> \
           -e GH_REPO=<填自定义�? \
           -e GH_CLIENTID=<填获取的>  \
           -e GH_CLIENTSECRET=<填获取的> \
           -e ARGO_AUTH='<填获取的 Argo json 或�?token>' \
           -e ARGO_DOMAIN=<填自定义�? \
           -e GH_BACKUP_USER=<选填，选填，选填! 如与 GH_USER 一致，可以不要该环境变�? \
           -e REVERSE_PROXY_MODE=<选填，选填，选填! 如想�?Nginx �?gRPCwebProxy 替代 Caddy 反代的话，请设置该变量并赋值为 `nginx` �?`grpcwebproxy`> \
           -e NO_AUTO_RENEW=<选填，选填，选填! 如果不需要自动在线同步最新的 backup.sh �?restore.sh，请设置该变量并赋值为 `1`> \
           -e DASHBOARD_VERSION=<选填，选填，选填! 指定面板的版本，�?`v0.00.00` 的格式，后续将固定在该版本不会升级，不填则使用默认的 `v0.20.13`> \
           fscarmen/argo-nezha
```

### docker-compose 部署
```
networks:
    nezha-dashboard:
        name: nezha-dashboard
services:
    argo-nezha:
        image: fscarmen/argo-nezha
        pull_policy: always
        container_name: nezha_dashboard
        restart: always
        networks:
            - nezha-dashboard
        environment:
            - GH_USER=<�?github 用户�?
            - GH_EMAIL=<�?github 邮箱>
            - GH_PAT=<填获取的>
            - GH_REPO=<填自定义�?
            - GH_CLIENTID=<填获取的>
            - GH_CLIENTSECRET=<填获取的>
            - ARGO_AUTH=<填获取的 Argo json 或�?token>
            - ARGO_DOMAIN=<填自定义�?
            - GH_BACKUP_USER=<选填，选填，选填! 如与 GH_USER 一致，可以不要该环境变�?
            - REVERSE_PROXY_MODE=<选填，选填，选填! 如想�?Nginx �?gRPCwebProxy 替代 Caddy 反代的话，请设置该变量并赋值为 `nginx` �?`grpcwebproxy`>
            - NO_AUTO_RENEW=<选填，选填，选填! 如果不需要自动在线同步最新的 backup.sh �?restore.sh，请设置该变量并赋值为 `1`>
            - DASHBOARD_VERSION=<选填，选填，选填! 指定面板的版本，�?`v0.00.00` 的格式，后续将固定在该版本不会升级，不填则使用默认的 `v0.20.13`>
```


## VPS 部署方式 2 --- 宿主�?```
bash <(wget -qO- https://raw.githubusercontent.com/fscarmen2/Argo-Nezha-Service-Container/main/dashboard.sh)
```


## 客户端接�?通过gRPC传输，无需额外配置。使用面板给到的安装方式，举�?```
curl -L https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -o nezha.sh && chmod +x nezha.sh && sudo ./nezha.sh install_agent nezha.seales.nom.za 443 eAxO9IF519fKFODlW0 --tls
```


## SSH 接入
* �?macOS + WindTerm 为例，其他根据使用的 SSH 工具，结合官方官方说明文�? https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/use_cases/ssh/#2-connect-as-a-user
* 官方 cloudflared 下载: https://github.com/cloudflare/cloudflared/releases
* 以下输入命令举例:
  SSH 用户�? root�?密码�?GH_CLIENTSECRET>
```
<file path>/cloudflared access ssh --hostname nezha.seales.nom.za/<GH_CLIENTID>
```

<img width="1180" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/507b037a-25c6-457f-b2b5-d54f4b70a2b6">
<img width="828" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/80284f0b-e2d7-4adb-982a-969aca0cb5f6">
<img width="955" alt="image" src="https://user-images.githubusercontent.com/92626977/233350802-754624e0-8456-4353-8577-1f5385fb8723.png">


## 手动备份数据
方法一: �?Github 备份库里�?`README.md` 文件内容改为 `backup`

<img width="970" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/c5b6bc4b-e69c-48ce-97d4-3f9be88515f3">

方法�? ssh 进去后，容器版本运行 `/dashboard/backup.sh`; 非容器版本运�?`/opt/nezha/dashboard/backup.sh`


## 手动更新备份和还原脚�?ssh 进去后，容器版本运行 `/dashboard/renew.sh`; 非容器版本运�?`/opt/nezha/dashboard/renew.sh`


## 自动还原备份
* 把需要还原的文件名改�?github 备份库里�?`README.md`，定时服务会每分钟检测更新，并把上次同步的文件名记录在本�?`/dbfile` 处以与在线的文件内容作比�?
下图为以还原文件名为 `dashboard-2023-04-23-13:08:37.tar.gz` 作示�?
![image](https://user-images.githubusercontent.com/92626977/233822466-c24e94f6-ba8a-47c9-b77d-aa62a56cc929.png)


## 手动还原备份
* ssh 进入容器后运行，github 备份库里�?tar.gz 文件名，格式: dashboard-2023-04-22-21:42:10.tar.gz
```
bash /dashboard/restore.sh <文件�?
```
<img width="1209" alt="image" src="https://user-images.githubusercontent.com/92626977/233792709-fb37b79c-c755-4db1-96ec-1039309ff932.png">

## 完美搬家
* 备份原哪吒的 `/dashboard` 文件夹，压缩备份�?`dashboard.tar.gz` 文件
```
tar czvf dashboard.tar.gz /dashboard
```
* 下载文件并放入私库，这个私库名要与新哪吒 <GH_REPO> 完全一致，并把该库�?README.md 的内容编辑为 `dashboard.tar.gz`
* 部署本项目新哪吒，完整填入变量即可。部署完成后，自动还原脚本会每分钟作检测，发现有新的内容即会自动还原，全程�?3 分钟


## 主体目录文件及说�?```
/dashboard/
|-- app                  # 哪吒面板主程�?|-- argo.json            # Argo 隧道 json 文件，记录着使用隧道的信�?|-- argo.yml             # Argo 隧道 yml 文件，用于在一同隧道下，根据不同域名来分流 web, gRPC �?ssh 协议的作�?|-- backup.sh            # 备份数据脚本
|-- restore.sh           # 还原备份脚本
|-- renew.sh             # 在线更新备份和还原文件的脚本
|-- dbfile               # 记录最新的还原或备份文件名
|-- resource             # 面板主题、语言和旗帜等资料的文件夹
|-- data
|   |-- config.yaml      # 哪吒面板的配置，�?Github OAuth2 / gRPC 域名 / 端口 / 是否启用 TLS 等信�?|   `-- sqlite.db        # SQLite 数据库文件，记录着面板设置的所�?severs �?cron 等信�?|-- entrypoint.sh        # 主脚本，容器运行后执�?|-- nezha.csr            # SSL/TLS 证书签名请求
|-- nezha.key            # SSL/TLS 证书的私钥信�?|-- nezha.pem            # SSL/TLS 证书文件
|-- cloudflared          # Cloudflare Argo 隧道主程�?|-- grpcwebproxy         # gRPC 反代主程�?|-- caddy                # Caddy 主程�?|-- Caddyfile            # Caddy 配置文件
`-- nezha-agent          # 哪吒客户端，用于监控本地 localhost
```


## 鸣谢下列作者的文章和项�?
* 热心的朝阳群�?Robin，讨论哪吒服务端与客户端的关系，从而诞生了此项�?* 哪吒官网: https://nezha.wiki/ , TG �? https://t.me/nezhamonitoring
* 共穷国际老中�? http://solitud.es/
* Akkia's Blog: https://blog.akkia.moe/
* 胡桃's Blog: https://blog.萝莉.org/
* HiFeng's Blog: https://www.hicairo.com/
* �?Cloudflare Tunnel 进行内网穿�? https://blog.outv.im/2021/cloudflared-tunnel/
* 如何�?GitHub Actions 添加自己�?Runner 主机: https://cloud.tencent.com/developer/article/1756690
* github self-hosted runner 添加与启�? https://blog.csdn.net/sinat_32188225/article/details/125978331
* 如何从Docker镜像中导出文�? https://www.pkslow.com/archives/extract-files-from-docker-image
* grpcwebproxy: https://github.com/improbable-eng/grpc-web/tree/master/go/grpcwebproxy
* Applexad 的哪吒官方改版的面板二进制文�? https://github.com/applexad/nezha-binary-build


## 免责声明:
* 本程序仅供学习了�? 非盈利目的，请于下载�?24 小时内删�? 不得用作任何商业用�? 文字、数据及图片均有所属版�? 如转载须注明来源�?* 使用本程序必循遵守部署免责声明。使用本程序必循遵守部署服务器所在地、所在国家和用户所在国家的法律法规, 程序作者不对使用者任何不当行为负责�?
