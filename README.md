[![Travis CI](https://travis-ci.org/cndjp/qicoo-ansible.svg?branch=master)](https://travis-ci.org/cndjp/qicoo-ansible)

# qicoo-ansible
qicoo-controller-01サーバから打つ事をにより発動するコントローラとそれをコード化したansibleで管理する。

以下のコマンドは `qicoo-ansible` レポジトリ配下で行う事を前提とする。

```
$ cd qicoo-ansible
```

## Alias
ansibleうんとかなんとかコマンド打つのが面倒なので便利なエイリアスを既に設定してあります。

```
$ alias a="ansible-playbook -i localhost, -c local"
```

普通はこんな風にコマンドを打つ発動する事を想定。

```
$ a cli/install-aws-cli.yml
```

## パラメータ

ほぼ全て
```
$ vim vars/all.yml
```

暗号化されたクレデンシャル情報
```
$ vim vars/all.yml
```

## デプロイする

### EKS以外のAWSリソースをデプロイする


```
$ a aws/create-rds-instance.yml
```

```
$ a aws/create-elasticache-cluster.yml
```

### EKSをデプロイする

```
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

これで `http://<qicoo-controller-01のIP>` で見れる。

### Arkでデプロイする

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

## 削除する。

### EKS以外のAWSリソースを削除する

```
$ a aws/delete-rds-instance.yml
```

```
$ a aws/delete-elasticache-cluster.yml
```

### EKSを削除する

```
$ a eks/delete-eks-env.yml
```

### Spinnakerを削除する

```
$ hal deploy clean
```
