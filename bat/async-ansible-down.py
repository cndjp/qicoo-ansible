#!/usr/bin/python3

from datetime import datetime
import asyncio
import os
import subprocess
from subprocess import Popen

os.environ['PATH'] = '/usr/local/bin:/usr/bin:/bin:/home/qicoo/.local/bin:/home/qicoo/bin:/home/qicoo/.local/bin:/home/qicoo/bin:/usr/local/bin:/usr/bin:/home/qicoo/go/bin:/home/qicoo/go-third-party/bin'
os.environ['KUBECONFIG'] = '/home/qicoo/.kube/config'
os.environ['AWS_CONFIG_FILE'] = '/home/qicoo/.aws/config'
os.environ['AWS_SHARED_CREDENTIALS_FILE'] = '/home/qicoo/.aws/credentials'

ansible_ctl = '/home/qicoo/.local/bin/ansible-playbook -i localhost, -c local --vault-password-file /home/qicoo/.vault_password '

def sh_exec(cmd):
    p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    p.wait()
    p_stdout, p_stderr = p.communicate()
    p_out = p_stdout + p_stderr
    return p_out.decode()

async def sh_coroutine(*args):
    # Create subprocess
    process = await asyncio.create_subprocess_shell(
        *args,
        # stdout must a pipe to be accessible as process.stdout
        stdout=asyncio.subprocess.PIPE)
    # Wait for the subprocess to finish
    stdout, stderr = await process.communicate()
    # Return stdout
    #return stdout.decode().strip()
    return stdout.decode()

def async_ansible_down(loop):

    now = datetime.now()
    now_str = now.strftime('%Y%m%d%H%M%S')
    log_file = 'qicoo-all-down_' + now_str + '.log'
    log_file_path = '/home/qicoo/qicoo-all-down/' + log_file

    command01 = ansible_ctl + '/home/qicoo/qicoo-ansible/ark/create-heptio-backup.yml'
    command02 = '/home/qicoo/qicoo-ansible/bat/hal-backup.sh'
    one = sh_exec(command01) 
    two = sh_exec(command02)

    command03 = ansible_ctl + '/home/qicoo/qicoo-ansible/eks/delete-eks-env.yml'
    command04 = ansible_ctl + '/home/qicoo/qicoo-ansible/aws/delete-rds-production.yml'
    command05 = ansible_ctl + '/home/qicoo/qicoo-ansible/aws/delete-rds-staging.yml'
    command06 = ansible_ctl + '/home/qicoo/qicoo-ansible/aws/delete-rds-development.yml'
    command07 = ansible_ctl + '/home/qicoo/qicoo-ansible/aws/delete-elasticache-production.yml'
    command08 = ansible_ctl + '/home/qicoo/qicoo-ansible/aws/delete-elasticache-staging.yml'
    command09 = ansible_ctl + '/home/qicoo/qicoo-ansible/aws/delete-elasticache-development.yml'
    commands = asyncio.gather(sh_coroutine(command03), \
                              sh_coroutine(command04), \
                              sh_coroutine(command05), \
                              sh_coroutine(command06), \
                              sh_coroutine(command07), \
                              sh_coroutine(command08), \
                              sh_coroutine(command09))

    three, four, five, six, seven, eight, nine  = loop.run_until_complete(commands)
    loop.close()

    stdoutlist = [one, two, three, four, five, six, seven, eight, nine]
    with open(log_file_path,'w') as f:
        for stdout in stdoutlist:
            f.write(stdout)

if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    async_ansible_down(loop)
