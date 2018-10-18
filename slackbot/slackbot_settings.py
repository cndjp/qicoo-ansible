# coding: utf-8

import subprocess

# botアカウントのトークンを指定
#token = subprocess.check_output('cat /home/qicoo/diamond_slack_token',shell=True)
API_TOKEN = subprocess.check_output('cat /home/qicoo/diamond_slack_token',shell=True).split()

# このbot宛のメッセージで、どの応答にも当てはまらない場合の応答文字列
DEFAULT_REPLY = "「上げて」 か 「下げて」 か 「見せて」って言ってくれよな！"

# プラグインスクリプトを置いてあるサブディレクトリ名のリスト
PLUGINS = ['plugins']
