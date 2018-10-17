# coding: utf-8

from slackbot.bot import respond_to     # @botname: で反応するデコーダ
from slackbot.bot import default_reply  # 該当する応答がない場合に反応するデコーダ
import subprocess

@respond_to('テスト')
def mention_func(message):
    message.reply('テストで失敗しても直せばいいのによぉ〜〜〜〜〜〜〜。')

@respond_to('上げて')
def mention_func(message):
    message.send('クレイジーダイアモンドォオオオオオオオ！！！')
    message.send('完璧じゃねーか、デプロイをしてる最中だという事を除いてよ〜〜〜〜〜〜〜〜〜〜。')
    subprocess.run(["/home/qicoo/qicoo-ansible/bat/all-up.sh"])
    message.reply('デプロイ終わったんじゃあないか。')

@respond_to('下げて')
def mention_func(message):
    message.send('クレイジーダイアモンドォオオオオオオオ！！！')
    message.send('全部消す？そいつはグレートだぜ、ちょっと待ってな。')
    subprocess.run(["/home/qicoo/qicoo-ansible/bat/all-down.sh"])
    message.reply('ほぅら、消し終わったぜ。')
