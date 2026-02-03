# Argo-Nezha-Service-Container 鍏煎 v0 鍜?v1

- 鏈」鐩?*鍏煎浜唍ezha鐨剉0鍜寁1鐗堟湰**锛屽熀浜巉scarmen澶т浆鐨?[Argo-Nezha-Service-Container](https://github.com/fscarmen2/Argo-Nezha-Service-Container) 淇敼銆?
- docker鐗堟湰杩樼粨鍚堜簡dsadsadsss澶т浆鐨?[Docker-for-Nezha-Argo-server-v0.x](https://github.com/dsadsadsss/Docker-for-Nezha-Argo-server-v0.x) 銆?
- 浣跨敤鍓嶏紝**璇峰厛闃呰 [F浣師椤圭洰鏁欑▼](https://github.com/debbide/nezha-argo#f%E4%BD%AC%E5%8E%9F%E9%A1%B9%E7%9B%AE%E6%95%99%E7%A8%8B)** 锛屼簡瑙ｅ叿浣撳浣曢儴缃诧紝鏈」鐩粎鍦ㄤ竴浜涘彉閲忎笂鏈夋墍涓嶅悓銆?
<details>
  <summary>鏇存柊鏃ュ織</summary>

- 2025.11.4
  - 淇v1闈㈡澘鐨勫浐瀹氱増鏈棶棰樸€?  - 娴嬭瘯vps鑴氭湰骞跺畬鎴愩€?- 2025.07.14
  - 澧炲姞浜哷AGENT_VERSION`鍙橀噺浠ユ帶鍒舵帰閽堢増鏈€?  - docker鐗堟湰鐩墠宸插緢瀹屽杽锛屼笉鍑烘剰澶栦互鍚庡皢浣涚郴鏇存柊锛堝叾瀹瀗ezha瀹樻柟涔熷凡姝ュ叆绋冲畾鍛ㄦ湡锛夈€?- 2025.07.01
  - 澧炲姞浜哷BACKUP_NUM`鍙橀噺浠ユ帶鍒跺浠戒粨搴撳唴鐨勫浠芥€绘暟锛岄粯璁や负5銆?- 2025.04.28
  - 淇浜哸rgo json閰嶇疆鏈€傞厤v1闈㈡澘鐨勯棶棰樸€?- 2025.04.20
  - 鏇存柊浜哛EADME.md銆?- 2025.04.14
  - 缁忚繃4澶╃殑娴嬭瘯锛宎rgo-nezha鍏煎v0鍜寁1鐗堟湰鍙互姝ｅ父浣跨敤銆?</details>

## 閮ㄧ讲鍓嶇殑鍑嗗宸ヤ綔
- 鍩熷悕鍑嗗
  - 鍦?`cf` 瀹樼綉涓婃壘鍒颁娇鐢ㄥ煙鍚嶇殑 `缃戠粶` 閫夐」锛屽皢 `gRPC` 寮€鍏虫墦寮€
  - 鑾峰彇 `argo` 璁よ瘉锛孾鐐瑰嚮鍓嶅線鏁欑▼](https://github.com/debbide/nezha-argo/blob/main/README.md#argo-%E8%AE%A4%E8%AF%81%E7%9A%84%E8%8E%B7%E5%8F%96%E6%96%B9%E5%BC%8F-json-%E6%88%96-token)
- github璐﹀彿鍑嗗
  - 鑾峰緱 `github` 鐨?`OAuth 2.0` 璁よ瘉鍜?`PAT` ,[鐐瑰嚮鍓嶅線鏁欑▼](https://github.com/debbide/nezha-argo/blob/main/README.md#%E5%87%86%E5%A4%87%E9%9C%80%E8%A6%81%E7%94%A8%E7%9A%84%E5%8F%98%E9%87%8F)锛屾敞鎰?`v0` 鍜?`v1` 鐨?`OAuth 2.0` 璁よ瘉鏄笉鍚岀殑锛孾鐐瑰嚮鍓嶅線浜嗚В鍖哄埆](https://github.com/debbide/nezha-argo#%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98%E4%BB%A5%E5%8F%8A%E5%9D%91%E7%82%B9)銆?## docker闀滃儚鍙婂叾鐜鍙橀噺璇存槑

docker闀滃儚锛?`mikehand888/argo-nezha:latest` 锛?鏀寔 amd64 鍜?arm64 鏋舵瀯銆?
[瀹瑰櫒骞冲彴涓婇儴缃叉暀绋嬶紝鐐瑰嚮鍓嶅線](https://github.com/debbide/nezha-argo/blob/main/README.md#paas-%E9%83%A8%E7%BD%B2%E5%AE%9E%E4%BE%8B)

[VPS涓奷ocker閮ㄧ讲鏁欑▼锛岀偣鍑诲墠寰€](https://github.com/debbide/nezha-argo/blob/main/README.md#vps-%E9%83%A8%E7%BD%B2%E6%96%B9%E5%BC%8F-1-----docker)


  | 鍙橀噺鍚?       | 鏄惁蹇呴』  | 澶囨敞 |
  | ------------ | ------   | ---- |
  | GH_USER             | v0蹇呭～ | github 鐨勭敤鎴峰悕锛岀敤浜庨潰鏉跨鐞嗘巿鏉?|
  | GH_CLIENTID         | v0蹇呭～ | 鍦?github 涓婄敵璇?|
  | GH_CLIENTSECRET     | v0蹇呭～ | 鍦?github 涓婄敵璇?|
  | GH_BACKUP_USER      | 澶囦唤鎴栧～ | 鍦?github 涓婂浠藉摢鍚掓湇鍔＄鏁版嵁搴撶殑 github 鐢ㄦ埛鍚嶏紝涓嶅～鍒欎笌闈㈡澘绠＄悊鎺堟潈鐨勮处鎴?GH_USER 涓€鑷? |
  | GH_REPO             | 澶囦唤蹇呭～ | 鍦?github 涓婂浠藉摢鍚掓湇鍔＄鏁版嵁搴撴枃浠剁殑 github 搴?|
  | GH_EMAIL            | 澶囦唤蹇呭～ | github 鐨勯偖绠憋紝鐢ㄤ簬澶囦唤搴撶殑 git 鎺ㄩ€?|
  | GH_PAT              | 澶囦唤蹇呭～ | github 鐨勭閽ワ紙PAT锛夛紝鐢ㄤ簬澶囦唤搴撶殑 git 鎺ㄩ€?|
  | REVERSE_PROXY_MODE  | 鍚?| 榛樿浣跨敤 Caddy 搴旂敤鏉ュ弽浠ｏ紝鍙互涓嶅～銆倂0鍙€?Nginx 鎴?gRPCwebProxy锛泇1蹇呴』鐢?Caddy |
  | ARGO_AUTH           | 蹇呭～ | Json: 浠?https://fscarmen.cloudflare.now.cc 鑾峰彇鐨?Argo Json<br> Token: 浠?Cloudflare 瀹樼綉鑾峰彇 |
  | ARGO_DOMAIN         | 蹇呭～ | Argo 鍩熷悕 |
  | NO_AUTO_RENEW       | 鍚?| 榛樿涓嶉渶瑕佽鍙橀噺锛屽嵆姣忓ぉ瀹氭椂鍚屾鍦ㄧ嚎鏈€鏂扮殑澶囦唤鍜岃繕鍘熻剼鏈€傚涓嶉渶瑕佽鍔熻兘锛岃缃鍙橀噺涓?`1` |
  | DASHBOARD_VERSION   | 鍚?| 鎸囧畾闈㈡澘鐨勭増鏈€俙v0.00.00` 鐨勬牸寮忓拰 `v1.00.00` 鐨勬牸寮忥紝濉啓浜嗗皢浼氭妸鐗堟湰鍥哄畾鍦ㄦ墍濉増鏈€備笉濉垯鏄渶鏂扮殑v1闈㈡澘 |
  | AGENT_VERSION       | 鍚?| 鎸囧畾鎺㈤拡鐨勭増鏈€俙v0.00.00` 鐨勬牸寮忓拰 `v1.00.00` 鐨勬牸寮忥紝濉啓浜嗗皢浼氭妸鐗堟湰鍥哄畾鍦ㄦ墍濉増鏈€備笉濉湁涓ょ鎯呭喌锛氬浜巚1闈㈡澘鏄繚鎸佹渶鏂扮殑v1鎺㈤拡锛涘浜巚0闈㈡澘鏄痸0.20.5鐗堟湰 |
  | PRO_PORT            | 鍚?| 瀹瑰櫒骞冲彴鐨勫紑鏀剧鍙ｏ紝涓嶅～榛樿涓?0銆傚鏋滃鍣ㄥ紑鏀剧殑绔彛涓嶄负80涓攁rgo闅ч亾浣跨敤鐨則oken锛屽垯淇敼姝ゅ骞舵墜鍔ㄤ慨鏀归毀閬撹缃噷瀵瑰簲鐨勭鍙?|
  | UUID                | 鍚?| 濉啓浼氭湁鑺傜偣锛屽湪鏃ュ織鏌ョ湅base64 |
  | BACKUP_TIME         | 鍚?| 鑷畾涔夊浠芥椂闂达紝涓嶅～榛樿涓?`0 4 * * *`锛屽嵆姣忓ぉ鍖椾含鏃堕棿4鐐瑰浠?|
  | BACKUP_NUM          | 鍚?| 鑷畾涔夊浠戒粨搴撲腑鐨勫浠芥€绘暟锛屼笉濉粯璁や负 5锛屽嵆浠撳簱閲屽彧淇濈暀5涓浠?|

## 鍦╒PS涓婁娇鐢ㄨ剼鏈儴缃?
```
bash <(wget -qO- https://raw.githubusercontent.com/debbide/nezha-argo/main/dashboard.sh)
```
璺熼殢鑴氭湰姝ラ鍗冲彲閮ㄧ讲瀹屾垚

## 甯歌闂銆佸潙鐐?  | 甯歌闂       | 娉ㄦ剰鍐呭  |
  | ------------ | ------   |
  | 鎺㈤拡涓嶄笂绾匡紝[鐐瑰嚮鍓嶅線鍩熷悕鍑嗗鏁欑▼](https://github.com/debbide/nezha-argo#%E5%87%86%E5%A4%87%E9%9C%80%E8%A6%81%E7%94%A8%E7%9A%84%E5%8F%98%E9%87%8F) | 璇峰湪 `cf` 闈㈡澘鏌ョ湅 `argo`鍩熷悕鐨?`grpc` 璁剧疆锛屼竴瀹氳寮€鍚紒杩樻湁鍙兘鏄煙鍚嶇殑闂锛屽彲浠ユ崲涓煙鍚嶈瘯璇?|
  | agent鐨勫畨瑁呭懡浠?| 绔彛闇€纭涓?`443` 锛宍tls` 闇€纭涓?`true` |
  | OAuth 2.0 | v0涓?`https://浣犵殑闈㈡澘鍩熷悕/oauth2/callback`锛寁1涓?`https://浣犵殑闈㈡澘鍩熷悕/api/v1/oauth2/callback` |
  | 浣跨敤澶囦唤锛孾鐐瑰嚮鍓嶅線澶囦唤鏁欑▼](https://github.com/debbide/nezha-argo?tab=readme-ov-file#%E6%89%8B%E5%8A%A8%E5%A4%87%E4%BB%BD%E6%95%B0%E6%8D%AE) | 鏈夌殑瀹瑰櫒閲嶅惎浼氫涪澶辨暟鎹紝闇€瑕佷娇鐢ㄥ浠斤紝闇€瑕?`GH_USER`鎴朻GH_BACKUP_USER`銆乣GH_REPO`銆乣GH_EMAIL`銆乣GH_PAT` 杩?涓彉閲忔湁鍊?|
  | 娉ㄦ剰鑷姩杩樺師 | 瀹瑰櫒鍦ㄤ慨鏀圭幆澧冨彉閲忓悗浼氶噸鏂伴儴缃诧紝娉ㄦ剰澶囦唤搴撲細鑷姩杩樺師澶囦唤 |
  | 浣跨敤鏈湴ssh锛孾鐐瑰嚮鍓嶅線ssh鏁欑▼](https://github.com/debbide/nezha-argo?tab=readme-ov-file#ssh-%E6%8E%A5%E5%85%A5) | 闇€瑕?`GH_CLIENTID`銆乣GH_CLIENTSECRET` 杩?涓彉閲忔湁鍊?|

* * *
<br>
<br>
<br>

# F浣師椤圭洰鏁欑▼

浣跨敤 Argo 闅ч亾鐨勫摢鍚掓湇鍔＄

Documentation: [English version](https://github.com/fscarmen2/Argo-Nezha-Service-Container/blob/main/README_EN.md) | 涓枃鐗?
* * *

# 鐩綍

- [椤圭洰鐗圭偣](README.md#椤圭洰鐗圭偣)
- [鍑嗗闇€瑕佺敤鐨勫彉閲廬(README.md#鍑嗗闇€瑕佺敤鐨勫彉閲?
- [Argo 璁よ瘉鐨勮幏鍙栨柟寮? json 鎴?token](README.md#argo-璁よ瘉鐨勮幏鍙栨柟寮?json-鎴?token)
- [PaaS 閮ㄧ讲瀹炰緥](README.md#PaaS-閮ㄧ讲瀹炰緥)
- [VPS 閮ㄧ讲鏂瑰紡 1 --- docker](README.md#vps-閮ㄧ讲鏂瑰紡-1-----docker)
- [VPS 閮ㄧ讲鏂瑰紡 2 --- 瀹夸富鏈篯(README.md#vps-閮ㄧ讲鏂瑰紡-2-----瀹夸富鏈?
- [瀹㈡埛绔帴鍏(README.md#瀹㈡埛绔帴鍏?
- [SSH 鎺ュ叆](README.md#ssh-鎺ュ叆)
- [鎵嬪姩澶囦唤鏁版嵁](README.md#鎵嬪姩澶囦唤鏁版嵁)
- [鎵嬪姩鏇存柊澶囦唤鍜岃繕鍘熻剼鏈琞(README.md#鎵嬪姩鏇存柊澶囦唤鍜岃繕鍘熻剼鏈?
- [鑷姩杩樺師澶囦唤](README.md#鑷姩杩樺師澶囦唤)
- [鎵嬪姩杩樺師澶囦唤](README.md#鎵嬪姩杩樺師澶囦唤)
- [瀹岀編鎼](README.md#瀹岀編鎼)
- [涓讳綋鐩綍鏂囦欢鍙婅鏄嶿(README.md#涓讳綋鐩綍鏂囦欢鍙婅鏄?
- [楦ｈ阿涓嬪垪浣滆€呯殑鏂囩珷鍜岄」鐩甝(README.md#楦ｈ阿涓嬪垪浣滆€呯殑鏂囩珷鍜岄」鐩?
- [鍏嶈矗澹版槑](README.md#鍏嶈矗澹版槑)

* * *

## 椤圭洰鐗圭偣:
* 閫傜敤鑼冨洿鏇村箍 --- 鍙鑳借繛閫氱綉缁滐紝灏辫兘瀹夎鍝悞鏈嶅姟绔紝濡?LXC, OpenVZ VPS锛孨as 铏氭嫙鏈?, Container PaaS 绛?* Argo 闅ч亾绐佺牬闇€瑕佸叕缃戝叆鍙ｇ殑闄愬埗 --- 浼犵粺鐨勫摢鍚掗渶瑕佹湁涓や釜鍏綉绔彛锛屼竴涓敤浜庨潰鏉跨殑璁块棶锛屽彟涓€涓敤浜庡鎴风涓婃姤鏁版嵁锛屾湰椤圭洰鍊熺敤 Cloudflare Argo 闅ч亾锛屼娇鐢ㄥ唴缃戠┛閫忕殑鍔炴硶
* IPv4 / v6 鍏峰鏇撮珮鐨勭伒娲绘€?--- 浼犵粺鍝悞闇€瑕佸鐞嗘湇鍔＄鍜屽鎴风鐨?IPv4/v6 鍏煎鎬ч棶棰橈紝杩橀渶瑕侀€氳繃 warp 绛夊伐鍏锋潵瑙ｅ喅涓嶅搴旂殑鎯呭喌銆傜劧鑰岋紝鏈」鐩彲浠ュ畬鍏ㄤ笉闇€瑕佽€冭檻杩欎簺闂锛屽彲浠ヤ换鎰忓鎺ワ紝鏇村姞鏂逛究鍜岀畝渚?* 涓€鏉?Argo 闅ч亾鍒嗘祦澶氫釜鍩熷悕鍜屽崗璁?--- 寤虹珛涓€鏉″唴缃戠┛閫忕殑 Argo 闅ч亾锛屽嵆鍙垎娴佷笁涓煙鍚?hostname)鍜屽崗璁?protocal)锛屽垎鍒敤浜庨潰鏉跨殑璁块棶(http)锛屽鎴风涓婃姤鏁版嵁(tcp)鍜?ssh锛堝彲閫夛級
* Grpc 鍙嶅悜浠ｇ悊鐨?gRPC 鏁版嵁绔彛 --- 閰嶄笂璇佷功鍋?tls 缁堢粨锛岀劧鍚?Argo 鐨勯毀閬撻厤缃敤 https 鏈嶅姟鎸囧悜杩欎釜鍙嶅悜浠ｇ悊锛屽惎鐢╤ttp2鍥炴簮锛実rpc(nezha)->Grpc Proxy->h2(argo)->cf cdn edge->agent
* 姣忓ぉ鑷姩澶囦唤 --- 鏁版嵁鎸佷箙鍖栦粠鏈湴鏀逛负绾夸笂锛屽寳浜椂闂存瘡澶?4 鏃?0 鍒嗚嚜鍔ㄥ浠芥暣涓摢鍚掗潰鏉挎枃浠跺す鍒版寚瀹氱殑 github 绉佸簱锛屽寘鎷潰鏉夸富棰橈紝闈㈡澘璁剧疆锛屾帰閽堟暟鎹拰闅ч亾淇℃伅锛屽浠戒繚鐣欒繎 5 澶╂暟鎹紱閴翠簬鍐呭鍗佸垎閲嶈锛屽繀椤昏鏀惧湪绉佸簱
* 姣忓ぉ鑷姩鏇存柊闈㈡澘鍜屾洿鏂拌剼鏈?-- 鍖椾含鏃堕棿姣忓ぉ 4 鏃?0 鍒嗚嚜鍔ㄦ娴嬫渶鏂扮殑瀹樻柟闈㈡澘鐗堟湰鍙婂浠借繕鍘熻剼鏈紝鏈夊崌绾ф椂鑷姩鏇存柊
* 姣忓ぉ鑷姩浼樺寲 SQLite 鏁版嵁搴?--- 鍖椾含鏃堕棿姣忓ぉ 4 鏃?0 鍒嗚嚜鍔ㄤ娇鐢?`sqlite3 "sqlite.db" 'VACUUM;'` 浼樺寲鐦﹁韩鏁版嵁搴?* 鎵?鑷竴浣撹繕鍘熷浠?--- 姣忓垎閽熸娴嬩竴娆″湪绾胯繕鍘熸枃浠剁殑鍐呭锛岄亣鍒版湁鏇存柊绔嬪埢杩樺師
* 榛樿鍐呯疆鏈満鎺㈤拡 --- 鑳藉緢鏂逛究鐨勭洃鎺ц嚜韬湇鍔″櫒淇℃伅

<img width="1609" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/ecd9d887-68f0-46f9-9a63-eb0275f066eb">


## 鍑嗗闇€瑕佺敤鐨勫彉閲?* 鍒?Cloudflare 瀹樼綉锛岄€夋嫨浣跨敤鐨勫煙鍚嶏紝鎵撳紑 `缃戠粶` 閫夐」灏?`gRPC` 寮€鍏虫墦寮€

<img width="1590" alt="image" src="https://user-images.githubusercontent.com/92626977/233138703-faab8596-a64a-40bb-afe6-52711489fbcf.png">

* 鑾峰彇 github 璁よ瘉鎺堟潈: https://github.com/settings/applications/new

闈㈡澘鍩熷悕鍔犱笂 `https://` 寮€澶达紝鍥炶皟鍦板潃鍐嶅姞涓?`/oauth2/callback` 缁撳熬

<img width="916" alt="image" src="https://user-images.githubusercontent.com/92626977/231099071-b6676f2f-6c7b-4e2f-8411-c134143cab24.png">
<img width="1122" alt="image" src="https://user-images.githubusercontent.com/92626977/231086319-1b625dc6-713b-4a62-80b1-cc5b2b7ef3ca.png">

* 鑾峰彇 github 鐨?PAT (Personal Access Token): https://github.com/settings/tokens/new

<img width="1226" alt="image" src="https://user-images.githubusercontent.com/92626977/233346036-60819f98-c89a-4cef-b134-0d47c5cc333d.png">
<img width="1148" alt="image" src="https://user-images.githubusercontent.com/92626977/233346508-273c422e-05c3-4c91-9fae-438202364787.png">

* 鍒涘缓 github 鐢ㄤ簬澶囦唤鐨勭搴? https://github.com/new

<img width="814" alt="image" src="https://user-images.githubusercontent.com/92626977/233345537-c5b9dc27-35c4-407b-8809-b0ef68d9ad55.png">


## Argo 璁よ瘉鐨勮幏鍙栨柟寮? json 鎴?token
Argo 闅ч亾璁よ瘉鏂瑰紡鏈?json 鍜?token锛屼娇鐢ㄤ袱涓柟寮忓叾涓箣涓€銆傛帹鑽愬墠鑰咃紝鐞嗙敱鑴氭湰浼氬鐞嗗ソ鎵€鏈夌殑 Argo 闅ч亾鍙傛暟鍜岃矾寰勶紝鍚庤€呴渶瑕佸埌 Cloudflare 瀹樼綉鎵嬪姩璁剧疆锛屽鏄撳嚭閿欍€?
### (鏂瑰紡 1 - Json):
#### 閫氳繃 Cloudflare Json 鐢熸垚缃戣交鏉捐幏鍙?Argo 闅ч亾 json 淇℃伅: https://fscarmen.cloudflare.now.cc

<img width="893" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/5b734a9d-b4fd-40ca-b7e6-5a1732a53175">

### (鏂瑰紡 2 - Token): 閫氳繃 Cloudflare 瀹樼綉锛屾墜鍔ㄧ敓鎴?Argo 闅ч亾 token 淇℃伅
#### 鍒?cf 瀹樼綉锛歨ttps://dash.cloudflare.com/
* 杩涘叆 zero trust 閲岀敓鎴?token 闅ч亾鍜屼俊鎭€?* 鍏朵腑鏁版嵁璺緞 443/https 涓?`proto.NezhaService`
* ssh 璺緞 22/ssh 涓?< client id >

<img width="1672" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/0c467d8b-5fbc-4bde-ac8a-db70ed8798f0">
<img width="1659" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/5aa4df19-f277-4582-8a4d-eef34a00085c">
<img width="1470" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/ec06ec20-a68d-405c-b6de-cd4c52cbd8c0">
<img width="1342" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/538707e1-a17b-4a0f-a8c0-63d0c7bc96aa">
<img width="1020" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/9f5778fd-aa94-4fda-9d85-552b68f6d530">
<img width="1652" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/d0fba15c-f41b-4ee4-bea3-f0506d9b2d23">
<img width="1410" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/228b8e86-32a8-479a-8a86-89ed9b8b5b5e">


## PaaS 閮ㄧ讲瀹炰緥
闀滃儚 `fscarmen/argo-nezha:latest` 锛?鏀寔 amd64 鍜?arm64 鏋舵瀯

鐢ㄥ埌鐨勫彉閲?  | 鍙橀噺鍚?       | 鏄惁蹇呴』  | 澶囨敞 |
  | ------------ | ------   | ---- |
  | GH_USER             | 鏄?| github 鐨勭敤鎴峰悕锛岀敤浜庨潰鏉跨鐞嗘巿鏉?|
  | GH_CLIENTID         | 鏄?| 鍦?github 涓婄敵璇?|
  | GH_CLIENTSECRET     | 鏄?| 鍦?github 涓婄敵璇?|
  | GH_BACKUP_USER      | 鍚?| 鍦?github 涓婂浠藉摢鍚掓湇鍔＄鏁版嵁搴撶殑 github 鐢ㄦ埛鍚嶏紝涓嶅～鍒欎笌闈㈡澘绠＄悊鎺堟潈鐨勮处鎴?GH_USER 涓€鑷? |
  | GH_REPO             | 鍚?| 鍦?github 涓婂浠藉摢鍚掓湇鍔＄鏁版嵁搴撴枃浠剁殑 github 搴?|
  | GH_EMAIL            | 鍚?| github 鐨勯偖绠憋紝鐢ㄤ簬澶囦唤鐨?git 鎺ㄩ€佸埌杩滅▼搴?|
  | GH_PAT              | 鍚?| github 鐨?PAT |
  | REVERSE_PROXY_MODE  | 鍚?| 榛樿浣跨敤 Caddy 搴旂敤鏉ュ弽浠ｏ紝杩欐椂鍙互涓嶅～鍐欒鍙橀噺锛涘闇€ Nginx 鎴?gRPCwebProxy 鍙嶄唬锛岃璁剧疆璇ュ€间负 `nginx ` 鎴?`grpcwebproxy` |
  | ARGO_AUTH           | 鏄?| Json: 浠?https://fscarmen.cloudflare.now.cc 鑾峰彇鐨?Argo Json<br> Token: 浠?Cloudflare 瀹樼綉鑾峰彇 |
  | ARGO_DOMAIN         | 鏄?| Argo 鍩熷悕 |
  | NO_AUTO_RENEW       | 鍚?| 榛樿涓嶉渶瑕佽鍙橀噺锛屽嵆姣忓ぉ瀹氭椂鍚屾鍦ㄧ嚎鏈€鏂扮殑澶囦唤鍜岃繕鍘熻剼鏈€傚涓嶉渶瑕佽鍔熻兘锛岃缃鍙橀噺锛屽苟璧嬪€间负 `1` |
  | DASHBOARD_VERSION   | 鍚?| 鎸囧畾闈㈡澘鐨勭増鏈紝浠?`v0.00.00` 鐨勬牸寮忥紝鍚庣画灏嗗浐瀹氬湪璇ョ増鏈笉浼氬崌绾э紝涓嶅～鍒欎娇鐢ㄩ粯璁ょ殑 `v0.20.13` |

Koyeb

[![Deploy to Koyeb](https://www.koyeb.com/static/images/deploy/button.svg)](https://app.koyeb.com/deploy?type=docker&name=nezha&ports=80;http;/&env[GH_USER]=&env[GH_CLIENTID]=&env[GH_CLIENTSECRET]=&env[GH_REPO]=&env[GH_EMAIL]=&env[GH_PAT]=&env[ARGO_AUTH]=&env[ARGO_DOMAIN]=&image=docker.io/fscarmen/argo-nezha)

<img width="927" alt="image" src="https://user-images.githubusercontent.com/92626977/231088411-fbac3e6e-a8a6-4661-bcf8-7c777aa8ffeb.png">
<img width="750" alt="image" src="https://user-images.githubusercontent.com/92626977/231088973-7134aefd-4c80-4559-8e40-17c3be11d27d.png">
<img width="877" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/8cfdb9ab-5fb6-483f-a382-47aef0d64bea">
<img width="1187" alt="image" src="https://user-images.githubusercontent.com/92626977/231092893-c8f017a2-ee0e-4e28-bee3-7343158f0fa7.png">
<img width="500" alt="image" src="https://user-images.githubusercontent.com/92626977/231094144-df6715bc-c611-47ce-a529-03c43f38102e.png">


## VPS 閮ㄧ讲鏂瑰紡 1 --- docker
* 娉ㄦ剰: ARGO_DOMAIN= 鍚庨潰闇€瑕佹湁鍗曞紩鍙凤紝涓嶈兘鍘绘帀
* 濡傛灉 VPS 鏄?IPv6 only 鐨勶紝璇峰厛瀹夎 WARP IPv4 鎴栬€呭弻鏍? https://gitlab.com/fscarmen/warp
* 澶囦唤鐩綍涓哄綋鍓嶈矾寰勭殑 dashboard 鏂囦欢澶?
### docker 閮ㄧ讲

```
docker run -dit \
           --name nezha_dashboard \
           --pull always \
           --restart always \
           -e GH_USER=<濉?github 鐢ㄦ埛鍚? \
           -e GH_EMAIL=<濉?github 閭> \
           -e GH_PAT=<濉幏鍙栫殑> \
           -e GH_REPO=<濉嚜瀹氫箟鐨? \
           -e GH_CLIENTID=<濉幏鍙栫殑>  \
           -e GH_CLIENTSECRET=<濉幏鍙栫殑> \
           -e ARGO_AUTH='<濉幏鍙栫殑 Argo json 鎴栬€?token>' \
           -e ARGO_DOMAIN=<濉嚜瀹氫箟鐨? \
           -e GH_BACKUP_USER=<閫夊～锛岄€夊～锛岄€夊～! 濡備笌 GH_USER 涓€鑷达紝鍙互涓嶈璇ョ幆澧冨彉閲? \
           -e REVERSE_PROXY_MODE=<閫夊～锛岄€夊～锛岄€夊～! 濡傛兂鐢?Nginx 鎴?gRPCwebProxy 鏇夸唬 Caddy 鍙嶄唬鐨勮瘽锛岃璁剧疆璇ュ彉閲忓苟璧嬪€间负 `nginx` 鎴?`grpcwebproxy`> \
           -e NO_AUTO_RENEW=<閫夊～锛岄€夊～锛岄€夊～! 濡傛灉涓嶉渶瑕佽嚜鍔ㄥ湪绾垮悓姝ユ渶鏂扮殑 backup.sh 鍜?restore.sh锛岃璁剧疆璇ュ彉閲忓苟璧嬪€间负 `1`> \
           -e DASHBOARD_VERSION=<閫夊～锛岄€夊～锛岄€夊～! 鎸囧畾闈㈡澘鐨勭増鏈紝浠?`v0.00.00` 鐨勬牸寮忥紝鍚庣画灏嗗浐瀹氬湪璇ョ増鏈笉浼氬崌绾э紝涓嶅～鍒欎娇鐢ㄩ粯璁ょ殑 `v0.20.13`> \
           fscarmen/argo-nezha
```

### docker-compose 閮ㄧ讲
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
            - GH_USER=<濉?github 鐢ㄦ埛鍚?
            - GH_EMAIL=<濉?github 閭>
            - GH_PAT=<濉幏鍙栫殑>
            - GH_REPO=<濉嚜瀹氫箟鐨?
            - GH_CLIENTID=<濉幏鍙栫殑>
            - GH_CLIENTSECRET=<濉幏鍙栫殑>
            - ARGO_AUTH=<濉幏鍙栫殑 Argo json 鎴栬€?token>
            - ARGO_DOMAIN=<濉嚜瀹氫箟鐨?
            - GH_BACKUP_USER=<閫夊～锛岄€夊～锛岄€夊～! 濡備笌 GH_USER 涓€鑷达紝鍙互涓嶈璇ョ幆澧冨彉閲?
            - REVERSE_PROXY_MODE=<閫夊～锛岄€夊～锛岄€夊～! 濡傛兂鐢?Nginx 鎴?gRPCwebProxy 鏇夸唬 Caddy 鍙嶄唬鐨勮瘽锛岃璁剧疆璇ュ彉閲忓苟璧嬪€间负 `nginx` 鎴?`grpcwebproxy`>
            - NO_AUTO_RENEW=<閫夊～锛岄€夊～锛岄€夊～! 濡傛灉涓嶉渶瑕佽嚜鍔ㄥ湪绾垮悓姝ユ渶鏂扮殑 backup.sh 鍜?restore.sh锛岃璁剧疆璇ュ彉閲忓苟璧嬪€间负 `1`>
            - DASHBOARD_VERSION=<閫夊～锛岄€夊～锛岄€夊～! 鎸囧畾闈㈡澘鐨勭増鏈紝浠?`v0.00.00` 鐨勬牸寮忥紝鍚庣画灏嗗浐瀹氬湪璇ョ増鏈笉浼氬崌绾э紝涓嶅～鍒欎娇鐢ㄩ粯璁ょ殑 `v0.20.13`>
```


## VPS 閮ㄧ讲鏂瑰紡 2 --- 瀹夸富鏈?```
bash <(wget -qO- https://raw.githubusercontent.com/fscarmen2/Argo-Nezha-Service-Container/main/dashboard.sh)
```


## 瀹㈡埛绔帴鍏?閫氳繃gRPC浼犺緭锛屾棤闇€棰濆閰嶇疆銆備娇鐢ㄩ潰鏉跨粰鍒扮殑瀹夎鏂瑰紡锛屼妇渚?```
curl -L https://raw.githubusercontent.com/naiba/nezha/master/script/install.sh -o nezha.sh && chmod +x nezha.sh && sudo ./nezha.sh install_agent nezha.seales.nom.za 443 eAxO9IF519fKFODlW0 --tls
```


## SSH 鎺ュ叆
* 浠?macOS + WindTerm 涓轰緥锛屽叾浠栨牴鎹娇鐢ㄧ殑 SSH 宸ュ叿锛岀粨鍚堝畼鏂瑰畼鏂硅鏄庢枃妗? https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/use_cases/ssh/#2-connect-as-a-user
* 瀹樻柟 cloudflared 涓嬭浇: https://github.com/cloudflare/cloudflared/releases
* 浠ヤ笅杈撳叆鍛戒护涓句緥:
  SSH 鐢ㄦ埛鍚? root锛?瀵嗙爜锛?GH_CLIENTSECRET>
```
<file path>/cloudflared access ssh --hostname nezha.seales.nom.za/<GH_CLIENTID>
```

<img width="1180" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/507b037a-25c6-457f-b2b5-d54f4b70a2b6">
<img width="828" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/80284f0b-e2d7-4adb-982a-969aca0cb5f6">
<img width="955" alt="image" src="https://user-images.githubusercontent.com/92626977/233350802-754624e0-8456-4353-8577-1f5385fb8723.png">


## 鎵嬪姩澶囦唤鏁版嵁
鏂规硶涓€: 鎶?Github 澶囦唤搴撻噷鐨?`README.md` 鏂囦欢鍐呭鏀逛负 `backup`

<img width="970" alt="image" src="https://github.com/fscarmen2/Argo-Nezha-Service-Container/assets/92626977/c5b6bc4b-e69c-48ce-97d4-3f9be88515f3">

鏂规硶浜? ssh 杩涘幓鍚庯紝瀹瑰櫒鐗堟湰杩愯 `/dashboard/backup.sh`; 闈炲鍣ㄧ増鏈繍琛?`/opt/nezha/dashboard/backup.sh`


## 鎵嬪姩鏇存柊澶囦唤鍜岃繕鍘熻剼鏈?ssh 杩涘幓鍚庯紝瀹瑰櫒鐗堟湰杩愯 `/dashboard/renew.sh`; 闈炲鍣ㄧ増鏈繍琛?`/opt/nezha/dashboard/renew.sh`


## 鑷姩杩樺師澶囦唤
* 鎶婇渶瑕佽繕鍘熺殑鏂囦欢鍚嶆敼鍒?github 澶囦唤搴撻噷鐨?`README.md`锛屽畾鏃舵湇鍔′細姣忓垎閽熸娴嬫洿鏂帮紝骞舵妸涓婃鍚屾鐨勬枃浠跺悕璁板綍鍦ㄦ湰鍦?`/dbfile` 澶勪互涓庡湪绾跨殑鏂囦欢鍐呭浣滄瘮瀵?
涓嬪浘涓轰互杩樺師鏂囦欢鍚嶄负 `dashboard-2023-04-23-13:08:37.tar.gz` 浣滅ず渚?
![image](https://user-images.githubusercontent.com/92626977/233822466-c24e94f6-ba8a-47c9-b77d-aa62a56cc929.png)


## 鎵嬪姩杩樺師澶囦唤
* ssh 杩涘叆瀹瑰櫒鍚庤繍琛岋紝github 澶囦唤搴撻噷鐨?tar.gz 鏂囦欢鍚嶏紝鏍煎紡: dashboard-2023-04-22-21:42:10.tar.gz
```
bash /dashboard/restore.sh <鏂囦欢鍚?
```
<img width="1209" alt="image" src="https://user-images.githubusercontent.com/92626977/233792709-fb37b79c-c755-4db1-96ec-1039309ff932.png">

## 瀹岀編鎼
* 澶囦唤鍘熷摢鍚掔殑 `/dashboard` 鏂囦欢澶癸紝鍘嬬缉澶囦唤涓?`dashboard.tar.gz` 鏂囦欢
```
tar czvf dashboard.tar.gz /dashboard
```
* 涓嬭浇鏂囦欢骞舵斁鍏ョ搴擄紝杩欎釜绉佸簱鍚嶈涓庢柊鍝悞 <GH_REPO> 瀹屽叏涓€鑷达紝骞舵妸璇ュ簱鐨?README.md 鐨勫唴瀹圭紪杈戜负 `dashboard.tar.gz`
* 閮ㄧ讲鏈」鐩柊鍝悞锛屽畬鏁村～鍏ュ彉閲忓嵆鍙€傞儴缃插畬鎴愬悗锛岃嚜鍔ㄨ繕鍘熻剼鏈細姣忓垎閽熶綔妫€娴嬶紝鍙戠幇鏈夋柊鐨勫唴瀹瑰嵆浼氳嚜鍔ㄨ繕鍘燂紝鍏ㄧ▼绾?3 鍒嗛挓


## 涓讳綋鐩綍鏂囦欢鍙婅鏄?```
/dashboard/
|-- app                  # 鍝悞闈㈡澘涓荤▼搴?|-- argo.json            # Argo 闅ч亾 json 鏂囦欢锛岃褰曠潃浣跨敤闅ч亾鐨勪俊鎭?|-- argo.yml             # Argo 闅ч亾 yml 鏂囦欢锛岀敤浜庡湪涓€鍚岄毀閬撲笅锛屾牴鎹笉鍚屽煙鍚嶆潵鍒嗘祦 web, gRPC 鍜?ssh 鍗忚鐨勪綔鐢?|-- backup.sh            # 澶囦唤鏁版嵁鑴氭湰
|-- restore.sh           # 杩樺師澶囦唤鑴氭湰
|-- renew.sh             # 鍦ㄧ嚎鏇存柊澶囦唤鍜岃繕鍘熸枃浠剁殑鑴氭湰
|-- dbfile               # 璁板綍鏈€鏂扮殑杩樺師鎴栧浠芥枃浠跺悕
|-- resource             # 闈㈡澘涓婚銆佽瑷€鍜屾棗甯滅瓑璧勬枡鐨勬枃浠跺す
|-- data
|   |-- config.yaml      # 鍝悞闈㈡澘鐨勯厤缃紝濡?Github OAuth2 / gRPC 鍩熷悕 / 绔彛 / 鏄惁鍚敤 TLS 绛変俊鎭?|   `-- sqlite.db        # SQLite 鏁版嵁搴撴枃浠讹紝璁板綍鐫€闈㈡澘璁剧疆鐨勬墍鏈?severs 鍜?cron 绛変俊鎭?|-- entrypoint.sh        # 涓昏剼鏈紝瀹瑰櫒杩愯鍚庢墽琛?|-- nezha.csr            # SSL/TLS 璇佷功绛惧悕璇锋眰
|-- nezha.key            # SSL/TLS 璇佷功鐨勭閽ヤ俊鎭?|-- nezha.pem            # SSL/TLS 璇佷功鏂囦欢
|-- cloudflared          # Cloudflare Argo 闅ч亾涓荤▼搴?|-- grpcwebproxy         # gRPC 鍙嶄唬涓荤▼搴?|-- caddy                # Caddy 涓荤▼搴?|-- Caddyfile            # Caddy 閰嶇疆鏂囦欢
`-- nezha-agent          # 鍝悞瀹㈡埛绔紝鐢ㄤ簬鐩戞帶鏈湴 localhost
```


## 楦ｈ阿涓嬪垪浣滆€呯殑鏂囩珷鍜岄」鐩?
* 鐑績鐨勬湞闃崇兢浼?Robin锛岃璁哄摢鍚掓湇鍔＄涓庡鎴风鐨勫叧绯伙紝浠庤€岃癁鐢熶簡姝ら」鐩?* 鍝悞瀹樼綉: https://nezha.wiki/ , TG 缇? https://t.me/nezhamonitoring
* 鍏辩┓鍥介檯鑰佷腑鍖? http://solitud.es/
* Akkia's Blog: https://blog.akkia.moe/
* 鑳℃'s Blog: https://blog.钀濊帀.org/
* HiFeng's Blog: https://www.hicairo.com/
* 鐢?Cloudflare Tunnel 杩涜鍐呯綉绌块€? https://blog.outv.im/2021/cloudflared-tunnel/
* 濡備綍缁?GitHub Actions 娣诲姞鑷繁鐨?Runner 涓绘満: https://cloud.tencent.com/developer/article/1756690
* github self-hosted runner 娣诲姞涓庡惎鍔? https://blog.csdn.net/sinat_32188225/article/details/125978331
* 濡備綍浠嶥ocker闀滃儚涓鍑烘枃浠? https://www.pkslow.com/archives/extract-files-from-docker-image
* grpcwebproxy: https://github.com/improbable-eng/grpc-web/tree/master/go/grpcwebproxy
* Applexad 鐨勫摢鍚掑畼鏂规敼鐗堢殑闈㈡澘浜岃繘鍒舵枃浠? https://github.com/applexad/nezha-binary-build


## 鍏嶈矗澹版槑:
* 鏈▼搴忎粎渚涘涔犱簡瑙? 闈炵泩鍒╃洰鐨勶紝璇蜂簬涓嬭浇鍚?24 灏忔椂鍐呭垹闄? 涓嶅緱鐢ㄤ綔浠讳綍鍟嗕笟鐢ㄩ€? 鏂囧瓧銆佹暟鎹強鍥剧墖鍧囨湁鎵€灞炵増鏉? 濡傝浆杞介』娉ㄦ槑鏉ユ簮銆?* 浣跨敤鏈▼搴忓繀寰伒瀹堥儴缃插厤璐ｅ０鏄庛€備娇鐢ㄦ湰绋嬪簭蹇呭惊閬靛畧閮ㄧ讲鏈嶅姟鍣ㄦ墍鍦ㄥ湴銆佹墍鍦ㄥ浗瀹跺拰鐢ㄦ埛鎵€鍦ㄥ浗瀹剁殑娉曞緥娉曡, 绋嬪簭浣滆€呬笉瀵逛娇鐢ㄨ€呬换浣曚笉褰撹涓鸿礋璐ｃ€?

