# coding: utf-8

from slackbot.bot import listen_to      # チャネル内発言で反応するデコーダ
from slackbot.bot import default_reply  # 該当する応答がない場合に反応するデコーダ
import subprocess

@listen_to('上げて')
def listen_func(message):
    message.send('クレイジーダイアモンドォオオオオオオオ！！！')
    message.send('完璧じゃねーか、デプロイをしてる最中だという事を除いてよ〜〜〜〜〜〜〜〜〜〜。')
    subprocess.run(["/home/qicoo/test.sh"])
    message.reply('デプロイ終わったんじゃあないか。')

@listen_to('下げて')
def listen_func(message):
    message.send('クレイジーダイアモンドォオオオオオオオ！！！')
    message.send('全部消す？そいつはグレートだぜ、ちょっと待ってな。')
    subprocess.run(["/home/qicoo/test.sh"])
    message.reply('ほぅら、消し終わったぜ。')
