負荷試験ツールの使い方
======================
gatling.qicoo.tokyoが、Gatlingベースの負荷試験ツール一式が入った環境。gatling.qicoo.tokyoにsshアクセスして、そこから負荷試験を実行できる。


Gatling実行環境へのアクセス
---------------------------

    ssh -i [secret key] ec2-user@gatling.qicoo.tokyo


負荷試験の手順
--------------

### 1. Gatling Homeに移動


    cc gatling/gatling-charts-highcharts-bundle-3.0.1.1/

### 2. Gatling 起動

    JAVA_OPTS="[オプション]" bin/gatling.sh

オプションは例えばこんな感じに指定（詳細は後述）

    JAVA_OPTS="-Dusers=10 -Dduring=30" bin/gatling.sh

### 3. シナリオの選択とDescriptionの入力

以下のインタラクションには、READのテストのとき-> `6 + [Return]`、WRITEのテストのとき`7 + [Return]`を入力

```
Choose a simulation number:
     [0] computerdatabase.BasicSimulation
     [1] computerdatabase.advanced.AdvancedSimulationStep01
     [2] computerdatabase.advanced.AdvancedSimulationStep02
     [3] computerdatabase.advanced.AdvancedSimulationStep03
     [4] computerdatabase.advanced.AdvancedSimulationStep04
     [5] computerdatabase.advanced.AdvancedSimulationStep05
     [6] qicoo.QicooRead
     [7] qicoo.QicooWrite
```

descriptionの入力を求められるので、適当な文字列を入れて`[Return]`。

    Select run description (optional)
    write | post:10 [r/s] | like:200 [r/s] | duration:5 [min]     <----こういうのを書いておく

以上で試験開始！

### 4. レポートの回収
テストが終了すると、以下のようなメッセージが出る。

    Please open the following file: /home/ec2-user/gatling/gatling-charts-highcharts-bundle-3.0.1.1/results/qicooread-20181201170252035/index.html

index.htmlが入っているディレクトリをまるごとscpなどで回収し、ブラウザでindex.htmlを開くと、レポートを参照できる。


オプション
----------

### READ

オプション名 | 説明 | デフォルト値
-|-|-
baseUrl|負荷がけ対象のURLの、ホストパートまでの文字列。デフォルトはステージング環境|https://api-s.qicoo.tokyo
users|ピーク時の同時リクエスト数 [r/s]|12
start|一覧取得APIのstartパラメータの設定値|1
end|一覧取得APIのendパラメータの設定値|100
sort|一覧取得APIのsortパラメータの設定値|created_at
order|一覧取得APIのorderパラメータの設定値|desc
during|負荷テストを行う時間 [s]。この値の最初の1/3で0からピークリクエスト数まで上げていき、次の1/3でピークリクエスト数を維持。最後の1/3で0まで落とす。|12

### WRITE

オプション名 | 説明 | デフォルト値
-|-|-
baseUrl|負荷がけ対象のURLの、ホストパートまでの文字列。デフォルトはステージング環境|https://api-s.qicoo.tokyo
postUsers|ピーク時の質問投稿の同時リクエスト数 [r/s]|12
likeUsers|ピーク時のLikeの同時リクエスト数 [r/s]|12
likeQid|Likeする質問のQID。固定で1個の質問にLikeしまくる|fcfd4f19-0623-47cc-a078-c99d6112b6d4
during|負荷テストを行う時間 [s]。この値の最初の1/3で0からピークリクエスト数まで上げていき、次の1/3でピークリクエスト数を維持。最後の1/3で0まで落とす。|12


JKDまでの性能目標
-----------------
以下のテストが捌ければOKだと思われ。

### READ

    JAVA_OPTS="-Dusers=500 -Dduring=300" bin/gatling.sh

### WRITE
（likeQidパラメータは、その時登録されている質問のQIDに書き換える）

    JAVA_OPTS="-DpostUsers=10 -DlikeUsers=200 -DlikeQid=8456f373-0c58-4547-ad43-fb2f26bf3a80 -Dduring=300" bin/gatling.sh