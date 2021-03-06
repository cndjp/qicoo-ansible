# coding: utf-8

from slackbot.bot import respond_to     # @botname: で反応するデコーダ
from datetime import datetime
import subprocess
from subprocess import Popen
import os
import requests
from psutil import process_iter
from signal import SIGTERM # or SIGKILL
import psutil
import time
import asyncio

flag = 0

def flag2zero():
    global flag
    flag = 0

def flag2one():
    global flag
    flag = 1

def file2slack(filename, path):
    files = {'file': open(path, 'rb')}
    param = {
        'token': subprocess.check_output('cat /home/qicoo/diamond_slack_token',shell=True).split(),
        'channels': "GDG0S7V9R",
        'filename': filename,
        'title': filename
    }
    requests.post(url="https://slack.com/api/files.upload",params=param, files=files) 

def list2exec(cmdlist):
    for cmd in cmdlist:
        os.system(cmd)

def setup_logfile(s):
    now = datetime.now()
    now_str = now.strftime('%Y%m%d%H%M%S')
    log_file = s + '_' + now_str + '.log'
    log_file_path = '/home/qicoo/' + s + '/' + log_file
    return log_file, log_file_path

def check2connect_spinnaker(message):
    i=0
    INCONNECTED=True
    USERNAME = ""
    PASSWORD = ""
    URL = 'https://spinnaker.qicoo.tokyo'
    with open("/home/qicoo/diamond_spinnaker_username", "r") as USERNAME_FILE:
            USERNAME = USERNAME_FILE.read().strip()

    with open("/home/qicoo/diamond_spinnaker_password", "r") as PASSWORD_FILE:
            PASSWORD = PASSWORD_FILE.read().strip()

    for proc in process_iter():
        if proc.name() == 'kubectl':
            for conns in proc.connections(kind='inet'):
                if conns.laddr.port in [8084, 9000] :
                    message.send('さっき繋いだ分が残ってたみてーだ、消しておくぜ。')
                    try:
                        proc.send_signal(SIGTERM)
                    except Exception:
                        continue
                    if i < 10:
                        i+=1
                        time.sleep(1)
                        continue
                    else:
                        message.send('悪りぃ、上手く切れねーみてぇだ')
                        return

    Popen( 'hal deploy connect', shell=True )
    while INCONNECTED:
        try:
            r = requests.get(url=URL, auth=(USERNAME, PASSWORD))
            if r.status_code == 200:
                INCONNECTED=False
            else:
                if i < 10:
                    i+=1
                    time.sleep(2)
                else:
                    message.send('悪りぃ、上手く動いてねーみてぇだ')
                    return
        except Exception:
            if i < 10:
                i+=1
                time.sleep(2)
            else:
                message.send('悪りぃ、上手く動いてねーみてぇだ')
                return

    msg = '```URL: ' + URL + '\n'
    msg += 'USERNAME: ' + USERNAME + '\n'
    msg += 'PASSWORD: ' + PASSWORD + '```'
    message.send(msg)

@respond_to('テスト')
def mention_func(message):
    message.reply('テストで失敗しても直せばいいのによぉ〜〜〜〜〜〜〜。')

@respond_to(r'^すけえる\s+\S.*')
def mention_func(message):
    if flag == 1:
        message.send('ちょっと待てって。オレはバカだから一つの事しかできねぇんでよぉ。')
        return

    flag2one()

    log_file, log_file_path = setup_logfile('qicoo-bot-scale')

    text = message.body['text']
    tmp, num = text.split(None, 1)
    cmd = 'sudo -u qicoo /home/qicoo/qicoo-ansible/bat/bot-scale.sh ' + log_file + ' ' + num
    if num.isdigit():
        msg = 'りょ〜〜〜〜かいっ！EKSノードを「' + num + '」個に すけえる するぜ！'
        message.send(msg)
        os.system(cmd)
        file2slack(log_file, log_file_path)
        message.reply('ふ〜〜〜〜これでオッケーか？')
    else:
        message.reply('おっと、すけえるの後は数字で指定してくれよな!')

    flag2zero()


@respond_to('調べて')
def mention_func(message):
    message.send('ちぃとばかし見てみるか・・・。')

    log_file, log_file_path = setup_logfile('qicoo-aws-status')

    cmd1 = 'sudo -u qicoo /home/qicoo/qicoo-ansible/check/check-route53-record.sh ' + log_file_path
    cmd2 = 'sudo -u qicoo /home/qicoo/qicoo-ansible/check/check-rds-status.sh ' + log_file_path
    cmd3 = 'sudo -u qicoo /home/qicoo/qicoo-ansible/check/check-ecache-status.sh ' + log_file_path
    cmd4 = 'sudo -u qicoo /home/qicoo/qicoo-ansible/check/check-eks-status.sh ' + log_file_path 
    cmd5 = 'sudo -u qicoo /home/qicoo/qicoo-ansible/check/check-ec2-status.sh ' + log_file_path
    cmd6 = 'sudo -u qicoo /home/qicoo/qicoo-ansible/check/check-cfn-status.sh ' + log_file_path

    cmdlist = [cmd1, cmd2, cmd3, cmd4, cmd5, cmd6]
    list2exec(cmdlist)

    file2slack(log_file, log_file_path)

@respond_to('繋げて')
def mention_func(message):
    check2connect_spinnaker(message)
    message.reply('繋げておいたぜ。')

@respond_to('戻して')
def mention_func(message):
    if flag == 1:
        message.send('ちょっと待てって。オレはバカだから一つの事しかできねぇんでよぉ。')
        return

    flag2one()
    log_file, log_file_path = setup_logfile('qicoo-bot-restore')
    cmd = 'sudo -u qicoo /home/qicoo/qicoo-ansible/bat/bot-restore.sh  ' + log_file

    message.send('ダラララララララララララララララ！！！')
    os.system(cmd)
    message.reply('よく分からねえが、元に戻っちまったと思うぜ。')

    file2slack(log_file, log_file_path)
    flag2zero()

@respond_to(r'^覚えて\s.*')
def mention_func(message):
    if flag == 1:
        message.send('ちょっと待てって。オレはバカだから一つの事しかできねぇんでよぉ。')
        return

    flag2one()

    now = datetime.now()
    now_str = now.strftime('%Y%m%d%H%M%S')
    text = message.body['text']
    tmp, msg = text.split(None, 1)

    if msg == 'クラスター':
        log_file = 'qicoo-ark-backup_' + now_str + '.log'
        log_file_path = '/home/qicoo/qicoo-ark-backup/' + log_file
        cmd = 'sudo -u qicoo /home/qicoo/qicoo-ansible/bat/bot-backup.sh  ' + log_file
    elif msg == 'プロメテウス':
        log_file = 'qicoo-prometheus-backup_' + now_str + '.log'
        log_file_path = '/home/qicoo/qicoo-prometheus-backup/' + log_file
        cmd = 'sudo -u qicoo /home/qicoo/qicoo-ansible/bat/ebs-snapshot.sh ' + log_file
    else:
        message.send('クラスターかプロメテウスって言ってくれよな！')
        return

    message.send('オーラオラオラオラオラオラオラオラ！！！！！！！！！')
    os.system(cmd)
    message.reply('一生その形で生きていくんだな・・・お似合いだぜ！！')

    file2slack(log_file, log_file_path)
    flag2zero()

@respond_to('見せて')
def mention_func(message):
    if flag == 1:
        message.send('ちょっと待てって。オレはバカだから一つの事しかできねぇんでよぉ。')
        return

    flag2one()

    log_file, log_file_path = setup_logfile('qicoo-infra-all')

    kube_config = 'kubeconfig'
    kube_config_path = '/home/qicoo/.kube/config'
    title1 = 'sudo -u qicoo echo [kubectl] >> ' + log_file_path
    cmd1 = 'sudo -u qicoo kubectl get all --all-namespaces >> ' + log_file_path
    title2 = 'sudo -u qicoo echo [Amazon RDS for MySQL] >> ' + log_file_path
    cmd2 = 'sudo -u qicoo /home/qicoo/.local/bin/aws rds describe-db-instances --output table >> ' + log_file_path
    title3 = 'sudo -u qicoo echo [Amazon ElastiCache] >> ' + log_file_path
    cmd3 = 'sudo -u qicoo /home/qicoo/.local/bin/aws elasticache describe-cache-clusters --output table >> ' + log_file_path
    title4 = 'sudo -u qicoo echo [Amazon EKS Cluster] >> ' + log_file_path
    cmd4 = 'sudo -u qicoo /home/qicoo/.local/bin/aws eks describe-cluster --name qicoo-eks-01 >> ' + log_file_path
    title5 = 'sudo -u qicoo echo [Amazon Route53] >> ' + log_file_path
    cmd5 = 'sudo -u qicoo /home/qicoo/.local/bin/aws route53 list-resource-record-sets --hosted-zone-id Z36M600IDI6K7I --output table >> ' + log_file_path

    cmdlist = [title1, cmd1, title2, cmd2, title3, cmd3, title4, cmd4, title5, cmd5]
    list2exec(cmdlist)

    message.send('グレートだぜ！！！！！')
    message.send('出しな・・・てめーの・・・「全て」をよぉ・・・・！')

    file2slack(kube_config, kube_config_path)
    file2slack(log_file, log_file_path)
    flag2zero()

@respond_to('上げて')
def mention_func(message):
    if flag == 1:
        message.send('ちょっと待てって。オレはバカだから一つの事しかできねぇんでよぉ。')
        return

    flag2one()

    log_file, log_file_path = setup_logfile('qicoo-all-up')
    cmd = 'sudo -u qicoo /home/qicoo/qicoo-ansible/bat/async-ansible-up.py ' + log_file_path

    message.send('クレイジーダイアモンドォオオオオオオオ！！！')
    message.send('完璧じゃねーか、デプロイをしてる最中だという事を除いてよ〜〜〜〜〜〜〜〜〜〜。')
    os.system(cmd)
    file2slack(log_file, log_file_path)

    message.send('ついでに繋げておくぜ。')
    check2connect_spinnaker(message)
    message.reply('デプロイ終わったんじゃあないか。')
    flag2zero()

@respond_to('下げて')
def mention_func(message):
    if flag == 1:
        message.send('ちょっと待てって。オレはバカだから一つの事しかできねぇんでよぉ。')
        return

    flag2one()

    log_file, log_file_path = setup_logfile('qicoo-all-down')
    cmd = 'sudo -u qicoo /home/qicoo/qicoo-ansible/bat/async-ansible-down.py ' + log_file_path

    message.send('クレイジーダイアモンドォオオオオオオオ！！！')
    message.send('全部消す？そいつはグレートだぜ！！ちょっと待ってな・・・。')
    os.system(cmd)
    message.reply('ほぅら、消し終わったぜ。')

    file2slack(log_file, log_file_path)
    flag2zero()

