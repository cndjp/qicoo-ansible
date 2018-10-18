# coding: utf-8

from slackbot.bot import respond_to     # @botname: で反応するデコーダ
#from slackbot.bot import default_reply  # 該当する応答がない場合に反応するデコーダ
from datetime import datetime
import subprocess
import os
import requests

@respond_to('テスト')
def mention_func(message):
    message.reply('テストで失敗しても直せばいいのによぉ〜〜〜〜〜〜〜。')

@respond_to('見せて')
def mention_func(message):
    now = datetime.now()
    now_str = now.strftime('%Y%m%d%H%M%S')
    log_file = 'qicoo-kubectl-getall_' + now_str + '.log'
    log_file_path = '/home/qicoo/qicoo-kubectl-getall/' + log_file
    title1 = 'sudo -u qicoo echo [kubectl] >> ' + log_file_path
    cmd1 = 'sudo -u qicoo kubectl get all --all-namespaces >> ' + log_file_path
    title2 = 'sudo -u qicoo echo [Amazon RDS for MySQL] >> ' + log_file_path
    cmd2 = 'sudo -u qicoo /home/qicoo/.local/bin/aws rds describe-db-instances --output table >> ' + log_file_path
    title3 = 'sudo -u qicoo echo [Amazon ElastiCache] >> ' + log_file_path
    cmd3 = 'sudo -u qicoo /home/qicoo/.local/bin/aws elasticache describe-cache-clusters --output table >> ' + log_file_path

    message.send('グレートだぜ！！！！！')
    message.send('出しな・・・てめーの・・・「全て」をよぉ・・・・！')
    os.system(title1)
    os.system(cmd1)
    os.system(title2)
    os.system(cmd2)
    os.system(title3)
    os.system(cmd3)

    files = {'file': open(log_file_path, 'rb')}
    param = {
        'token': subprocess.check_output('cat /home/qicoo/diamond_slack_token',shell=True).split(),
        'channels': "GDG0S7V9R",
        'filename': log_file,
        'title': log_file
    }
    requests.post(url="https://slack.com/api/files.upload",params=param, files=files)

@respond_to('上げて')
def mention_func(message):
    now = datetime.now()
    now_str = now.strftime('%Y%m%d%H%M%S')
    log_file = 'qicoo-all-up_' + now_str + '.log'
    log_file_path = '/home/qicoo/qicoo-all-up/' + log_file
    cmd = 'sudo -u qicoo /home/qicoo/qicoo-ansible/bat/all-up.sh ' + log_file

    message.send('クレイジーダイアモンドォオオオオオオオ！！！')
    message.send('完璧じゃねーか、デプロイをしてる最中だという事を除いてよ〜〜〜〜〜〜〜〜〜〜。')
    os.system(cmd)
    message.reply('デプロイ終わったんじゃあないか。')

    files = {'file': open(log_file_path, 'rb')}
    param = {
        'token': subprocess.check_output('cat /home/qicoo/diamond_slack_token',shell=True).split(),
        'channels': "GDG0S7V9R",
        'filename': log_file,
        'title': log_file
    }
    requests.post(url="https://slack.com/api/files.upload",params=param, files=files)


@respond_to('下げて')
def mention_func(message):
    now = datetime.now()
    now_str = now.strftime('%Y%m%d%H%M%S')
    log_file = 'qicoo-all-down_' + now_str + '.log'
    log_file_path = '/home/qicoo/qicoo-all-down/' + log_file
    cmd = 'sudo -u qicoo /home/qicoo/qicoo-ansible/bat/all-down.sh ' + log_file

    message.send('クレイジーダイアモンドォオオオオオオオ！！！')
    message.send('全部消す？そいつはグレートだぜ！！ちょっと待ってな・・・。')
    os.system(cmd)
    message.reply('ほぅら、消し終わったぜ。')

    files = {'file': open(log_file_path, 'rb')}
    param = {
    	'token': subprocess.check_output('cat /home/qicoo/diamond_slack_token',shell=True).split(),
        'channels': "GDG0S7V9R",
    	'filename': log_file,
    	'title': log_file
    }
    requests.post(url="https://slack.com/api/files.upload",params=param, files=files)
