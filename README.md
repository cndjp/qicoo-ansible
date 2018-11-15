[![Travis CI](https://travis-ci.org/cndjp/qicoo-ansible.svg?branch=master)](https://travis-ci.org/cndjp/qicoo-ansible)

# qicoo-ansible
`qicoo-controller-01`サーバから打つ事をにより発動するコントローラとそれをコード化したansibleで管理する。

# ブランチポリシー
`master` ブランチのみが安定版です。

## 作業ディレクトリ
以下で動かすことが前提です。

```
$ cd /home/qicoo/qicoo-ansible
```

## 東方仗助について
ほとんどのEKSやAWSリソースに対するアクションは `https://github.com/cndjp/qicoo-ansible/tree/master/slackbot` 配下にあるコードをソースとして動いている、  
`qicoo-controller-01` サーバ上のslackbotのサービスをcndjpのslackの `#qicoo-updown` からオペレーション出来るようにデザインしてあります。

また東方仗助が使用するバッチやスクリプトは `https://github.com/cndjp/qicoo-ansible/tree/master/bat` 配下にあります。

現状では以下のコマンドがサポートされています。

```
@東方 仗助 上げて:qicooのインフラを全部上げる
@東方 仗助 下げて:qicooのインフラを全部下げる
@東方 仗助 見せて:qicooの全インフラの状態を見る
@東方 仗助 覚えて:今の状態でbackupをとる
@東方 仗助 戻して:直前のbackupに戻す
@東方 仗助 繋げて:Spinnakerのweb画面を見れるようにする
@東方 仗助 試して:AWSリソースの状態だけみる
@東方 仗助 すけえる <数字>:<数字>個にEKSをスケールする
@東方 仗助 テスト:生存確認用
```

前述の通り、これらのコマンドを使えばインフラの準備から全削除、バックアップリストア、スケールアップまでサポートされています。
また、全てのコマンドの出力はログを取っており、そのログは `qicoo-controller-01` サーバ上の `/home/qicoo/`またはcndjpのslack上に送ります。

### 東方仗助のロック

東方仗助は同時に動作して欲しくないコマンドがあり、そのコマンドに対してはメモリ上にフラグを立ててロック排他制御を実施しています。  
ロック作動時には `ちょっと待てって。オレはバカだから一つの事しかできねぇんでよぉ。` と呟きます。  
コマンドリファレンス内で🔐マークがあるコマンドが対象です。

## 東方仗助コマンドリファレンス

### @東方 仗助 上げて🔐
このコマンドでは、以下のリソースをデプロイします(ソース:`https://github.com/cndjp/qicoo-ansible/blob/master/bat/async-ansible-up.py`)。  
Python3によって非同期、パイプラインの依存性解決が管理されており、大量のリソースをデプロイしながらも高速かつ正確に動きます。

```
[主なAWSリソース]
EKS:qicoo-eks-01
RDS:qicoo-rds-01,qicoo-rds-s01,qicoo-rds-d01
ElastiCache:qicoo-ecache-01,qicoo-ecache-s01,qicoo-ecache-d01
Route53:qicoo-rds-01,qicoo-rds-s01,qicoo-rds-d01,qicoo-ecache-01,qicoo-ecache-s01,qicoo-ecache-d01のCNAME

[主なk8sリソース]
ARK:`https://github.com/cndjp/qicoo-ansible/tree/master/ark/files/main`
External-dns:`https://github.com/cndjp/qicoo-ansible/blob/master/eks/files/eks-externaldns-deployment.yaml`,`https://github.com/cndjp/qicoo-ansible/blob/master/eks/files/test-externakdns-deployment.yaml`...more
Spinnaker: `hal deploy apply`を実行
Prometheus: `https://github.com/cndjp/qicoo-ansible/tree/master/spinnaker/files`
前回のリストア※1: `https://github.com/cndjp/qicoo-ansible/blob/master/bat/bot-restore.sh`を実行
```

尚このコマンドは`一応`冪等性が考慮されているので、何度実行してもOKです。  
が、もちろん完全ではないので、主にSpinnaker周りで一部うまく動作しないコンポーネントがあるかもしれませんが、そうしたら手で修正してください。

※1...リストアするk8sリソースは `https://github.com/cndjp/qicoo-ansible/blob/master/vars/all.yml#L144` に定義されている、ネームスペースに絞っています。

### @東方 仗助 下げて🔐
このコマンドでは、`@東方 仗助 上げて`によりデプロイされたリソースを `バックアップを取って` 全て削除します(ソース:`https://github.com/cndjp/qicoo-ansible/blob/master/bat/async-ansible-down.py`)。  
Python3によって非同期、パイプラインの依存性解決が管理されており、大量のリソースを消しながらも高速かつ正確に動きます。

尚、バックアップ対象は以下です。

```
・Kubernetes上の全リソース
・Spinnakerの設定
```

尚このコマンドは冪等性が考慮されているので、何度実行してもOKです。
下げての方は、安定して何度も実行できます。

### @東方 仗助 見せて
このコマンドでは、`qicoo`で使うほとんどのリソースの状態を確認できます。
以下のコマンドを打っています。

```
kubectl get all --all-namespaces
aws rds describe-db-instances --output table
aws elasticache describe-cache-clusters --output table
aws eks describe-cluster --name qicoo-eks-01
aws route53 list-resource-record-sets --hosted-zone-id Z36M600IDI6K7I --output table
```

### @東方 仗助 覚えて🔐
このコマンドでは、以下のリソースのバックアップをとります(ソース:`https://github.com/cndjp/qicoo-ansible/blob/master/bat/bot-backup.sh`)。

```
・現在のKubernetes上の全リソース
・現在のSpinnakerの設定
```

尚、Kubernetes上の全リソースは`heptio/ark`によってバックアップされ、S3上の `qicoo-backupbucket-01` に日付入りで永続化されています。

### @東方 仗助 戻して🔐
このコマンドでは、以下のリソースのリストアを実施します(ソース:`https://github.com/cndjp/qicoo-ansible/blob/master/bat/bot-restore.sh`)。

```
・直前のKubernetes上のうち、変数RESTORE_NAMESPACESで定義されたnamespaceのリソースのみ
・直前のSpinnakerの設定
```

### @東方 仗助 繋げて
このコマンドでは、EKS上にデプロイしたSpinnakerの `gate` と `deck` に対して、`qicoo-controller-01` 上のnginx(ソース:`https://github.com/cndjp/qicoo-ansible/tree/master/nginx`)がリバプロさせます。

これの発動後、cndjpのslackの `#qicoo-updown` に表示されるログイン情報をブラウザに入力すればSpinnakerのWeb UIが見れます。

尚、このコマンドは冪等性担保かつ例外処理に対応しているので、繰り返し打つと新たにSpinnakerの `gate` と `deck` に対してリバプロさせます。  
これは、例えばSpinnakerを繰り返しデプロイし直す際に使えます。

### @東方 仗助 試して
このコマンドでは、qicooで使用するAWS上のリソースの状態の一覧を表示します(ソース:`https://github.com/cndjp/qicoo-ansible/tree/master/check`)。

### @東方 仗助 すけえる <数字>🔐
このコマンドでは、指定した <数字> の個数にEKSのノードをスケールさせます。

すけえるすることによってノード数を増やす分にはEKS上のサービスが落ちる事はありません。  
ノードを減らす時は、新しくできた順にノードを消すようにしているのでそれに乗っ取ってポッドをどかす操作をする必要はあります。  
すごいクラウドネイティブでインスタ映えする機能です。

### @東方 仗助 テスト
このコマンドは、東方仗助サービスが生きているか確認します。  
`テストで失敗しても直せばいいのによぉ〜〜〜〜〜〜〜。` って返ってことなかったら確実に動いてません。

## Alias
ansibleのplaybookを適用する時のうんとかなんとかコマンド打つのが面倒なので便利なエイリアスを`qicoo-controller-01` サーバ上に既に設定してあります。

```
$ alias a="ansible-playbook -i localhost, -c local"
```

普通はこんな風にコマンドを発動できます。

```
$ a cli/install-aws-cli.yml
```

## 変数

ほぼ全て
```
$ vim vars/all.yml
```

暗号化されたクレデンシャル情報
```
$ vim vars/secret.yml
```

## 手でデプロイする
以下のコマンドで東方仗助を使わずにデプロイもできます。

### 全部デプロイする

```
$ bat/async-ansible-up.py /home/qicoo/qicoo-all-up/qicoo-all-up_$(date +%Y%m%d%H%M%S).log
```

### EKS以外のAWSリソースをデプロイする

#### RDS
```
$ a aws/create-rds-development.yml
$ a aws/create-rds-staging.yml
$ a aws/create-rds-production.yml
```

#### ElastiCache
```
$ a aws/create-elasticache-development.yml
$ a aws/create-elasticache-staging.yml
$ a aws/create-elasticache-production.yml
```

#### S3
```
$ a aws/create-s3-bucket.yml
```

#### Security Group
```
$ a aws/create-ec2-securitygroup.yml
```


### EKSをデプロイする

```
$ a eks/setup-eks-vpc.yml
$ a eks/setup-eks-env.yml
```

### Spinnakerをデプロイする

```
$ hal deploy apply
```

#### コンパネを見たい時は

```
$ hal deploy connect
```

これで `https://<qicoo-controller-01のIP>` で見れる。

### Arkコンポーネントでデプロイする

```
$ a ark/create-heptio-deployment.yml
```

## バックアップする

```
$ a ark/create-heptio-backup.yml
```

## リストアする

```
$ a ark/create-heptio-restore.yml
```

## 削除する

### 全部削除する

```
$ bat/async-ansible-down.py /home/qicoo/qicoo-all-down/qicoo-all-down_$(date +%Y%m%d%H%M%S).log
```

### EKS以外のAWSリソースを削除する

#### RDS
```
$ a aws/delete-rds-development.yml
$ a aws/delete-rds-staging.yml
$ a aws/delete-rds-production.yml
```

#### ElastiCache
```
$ a aws/delete-elasticache-development.yml
$ a aws/delete-elasticache-staging.yml
$ a aws/delete-elasticache-production.yml
```

### EKSを削除する

```
$ a eks/delete-eks-env.yml
```

### Spinnakerを削除する

```
$ hal deploy clean
```
