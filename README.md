# singularity で MongoDB 4.4のシャーディング・レプリカセットのクラスタ構築
## 概要
https://christina04.hatenablog.com/entry/mongodb-4.2-cluster

上記の記事をsingularityで再現しました。

本リポジトリの設定ファイルは1台のPCで全singularity instanceを実行できるようにすべてのmongod, mongosに異なるポート番号を割り当てています。
\*.conf, init_\*.js, init_\*.sh ファイル内のポート番号は環境に合わせて適宜変更してください。

各singularity instance を複数のサーバで実行する場合、mongos.conf, init_\*.js 内のlocalhostを各サーバのIPアドレスに変更してください。

本リポジトリの設定ファイルでは認証の設定を行っておりません。必要に応じて適宜設定を追加してください。

## singularity image の作成
```
$ singularity build mongodb.sif docker://mongo:4.4.3
```

## クラスタ構成
| 種類 | レプリカ名 | 台数 | singularity instance |
----|----|----|----
| config | configRepl | 3 | mongoc001, mongoc002, mongoc003 |
| mongod shard | shardRepl_1 | 3 | mongod001, mongod002, mongod003 |
| mongod shard | shardRepl_2 | 3 | mongod004, mongod005, mongod006 |
| mongod shard | shardRepl_3 | 3 | mongod007, mongod008, mongod009 |
| mongos | - | 1 | mongos |

- config: シャード情報の保存・管理を行います。3台のレプリカセット構成を取っています。
- mongod shard: データを保存します。ここでは、1つのmongod shardはPRIMARY, SECONDARY, SECONDARYの3台のレプリカセット構成を取っています。
- mongos: configサーバから情報を取得し、リクエストに対して適切なmongodへルーティングします。

## singularity instanceの起動
13個のシェルスクリプト start_\*.sh を実行することでsingularity instanceが起動されます。

singularity instance を複数のサーバで実行する場合、start_mongos.sh 実行前に mongos.conf 中の localhost を該当するサーバのIPアドレスに修正してください。

## 起動後の初期設定

mongoc001インスタンスが実行されているサーバで以下を実行します。init_mongoc.js内のlocalhostは適宜対象のサーバのIPアドレスに書き換えてください。

```
bash init_mongoc.sh
```

mongod001インスタンスが実行されているサーバで以下を実行します。init_shardRepl1.js内のlocalhostは適宜対象のサーバのIPアドレスに書き換えてください。

```
bash init_shardRepl1.sh
```

mongod004インスタンスが実行されているサーバで以下を実行します。init_shardRepl2.js内のlocalhostは適宜対象のサーバのIPアドレスに書き換えてください。

```
bash init_shardRepl2.sh
```

mongod007インスタンスが実行されているサーバで以下を実行します。init_shardRepl3.js内のlocalhostは適宜対象のサーバのIPアドレスに書き換えてください。

```
bash init_shardRepl3.sh
```

mongosインスタンスが実行されているサーバで以下を実行します。init_mongos.js内のlocalhostは適宜対象のサーバのIPアドレスに書き換えてください。

```
bash init_mongos.sh
```

## シャーディングの状態の確認
mongosインスタンスを実行しているサーバで以下のようにシャーディングの状態を確認できます。

```
$ singularity exec instance://mongos mongo --port 27013
MongoDB shell version v4.4.3
connecting to: mongodb://127.0.0.1:27013/?compressors=disabled&gssapiServiceName=mongodb
Implicit session: session { "id" : UUID("ef718f16-0f46-4106-8794-305ac61e0b52") }
MongoDB server version: 4.4.3
---
The server generated these startup warnings when booting: 
        2021-01-27T08:33:51.426+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted
---
mongos> sh.status()
--- Sharding Status --- 
  sharding version: {
  	"_id" : 1,
  	"minCompatibleVersion" : 5,
  	"currentVersion" : 6,
  	"clusterId" : ObjectId("6011201d33535d3936e0abb2")
  }
  shards:
        {  "_id" : "shardRepl_1",  "host" : "shardRepl_1/localhost:27004,localhost:27005,localhost:27006",  "state" : 1 }
        {  "_id" : "shardRepl_2",  "host" : "shardRepl_2/localhost:27007,localhost:27008,localhost:27009",  "state" : 1 }
        {  "_id" : "shardRepl_3",  "host" : "shardRepl_3/localhost:27010,localhost:27011,localhost:27012",  "state" : 1 }
  active mongoses:
        "4.4.3" : 1
  autosplit:
        Currently enabled: yes
  balancer:
        Currently enabled:  yes
        Currently running:  no
        Failed balancer rounds in last 5 attempts:  0
        Migration Results for the last 24 hours: 
                No recent migrations
  databases:
        {  "_id" : "config",  "primary" : "config",  "partitioned" : true }
mongos> exit
bye
```
