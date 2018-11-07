#!/usr/bin/python3

from datetime import datetime
import asyncio
import os
import subprocess
from subprocess import Popen
import sys

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
    out = stdout + stderr
    return out.decode()

def async_ansible_up(loop):

    log_file_path = sys.argv[1]

    command01 = ansible_ctl + '/home/qicoo/qicoo-ansible/eks/setup-eks-env.yml --skip-tags "no-routine"'
    command02 = ansible_ctl + '/home/qicoo/qicoo-ansible/aws/create-rds-production.yml'
    command03 = ansible_ctl + '/home/qicoo/qicoo-ansible/aws/create-rds-staging.yml'
    command04 = ansible_ctl + '/home/qicoo/qicoo-ansible/aws/create-rds-development.yml'
    command05 = ansible_ctl + '/home/qicoo/qicoo-ansible/aws/create-elasticache-production.yml'
    command06 = ansible_ctl + '/home/qicoo/qicoo-ansible/aws/create-elasticache-staging.yml'
    command07 = ansible_ctl + '/home/qicoo/qicoo-ansible/aws/create-elasticache-development.yml'
    commands = asyncio.gather(sh_coroutine(command01), \
                              sh_coroutine(command02), \
                              sh_coroutine(command03), \
                              sh_coroutine(command04), \
                              sh_coroutine(command05), \
                              sh_coroutine(command06), \
                              sh_coroutine(command07))

    one, two, three, four, five, six, seven  = loop.run_until_complete(commands)
    loop.close()

    command08 = ansible_ctl + '/home/qicoo/qicoo-ansible/ark/create-heptio-deployment.yml'
    command09 = '/home/qicoo/qicoo-ansible/bat/hal-restore.sh'
    command10 = 'hal deploy apply -q'
    command11 = ansible_ctl + '/home/qicoo/qicoo-ansible/ark/create-heptio-restore.yml'
    eight = sh_exec(command08)
    nine = sh_exec(command09)
    ten = sh_exec(command10)
    eleven = sh_exec(command11)

    stdoutlist = [one, two, three, four, five, six, seven, eight, nine, ten, eleven]
    with open(log_file_path,'w') as f:
        for stdout in stdoutlist:
            f.write(stdout)

if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    async_ansible_up(loop)
