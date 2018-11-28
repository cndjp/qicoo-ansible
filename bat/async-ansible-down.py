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
    return stdout.decode()

def async_ansible_down(loop):

    log_file_path = sys.argv[1]

    command01 = ansible_ctl + '/home/qicoo/qicoo-ansible/ark/create-heptio-backup.yml'
    command02 = '/home/qicoo/qicoo-ansible/bat/hal-backup.sh'
    command03 = '/home/qicoo/qicoo-ansible/bat/elb-all-down.sh'
    one =   sh_exec(command01) 
    two =   sh_exec(command02)
    three = sh_exec(command03)

    command04 = ansible_ctl + '/home/qicoo/qicoo-ansible/eks/delete-eks-env.yml'
    command05 = ansible_ctl + '/home/qicoo/qicoo-ansible/aws/delete-rds-production.yml'
    command06 = ansible_ctl + '/home/qicoo/qicoo-ansible/aws/delete-rds-staging.yml'
    command07 = ansible_ctl + '/home/qicoo/qicoo-ansible/aws/delete-rds-development.yml'
    command08 = ansible_ctl + '/home/qicoo/qicoo-ansible/aws/delete-elasticache-production.yml'
    command09 = ansible_ctl + '/home/qicoo/qicoo-ansible/aws/delete-elasticache-staging.yml'
    command10 = ansible_ctl + '/home/qicoo/qicoo-ansible/aws/delete-elasticache-development.yml'
    command11 = ansible_ctl + '/home/qicoo/qicoo-ansible/aws/delete-ec2-gatling.yml'
    commands = asyncio.gather(sh_coroutine(command04), \
                              sh_coroutine(command05), \
                              sh_coroutine(command06), \
                              sh_coroutine(command07), \
                              sh_coroutine(command08), \
                              sh_coroutine(command09), \
                              sh_coroutine(command10), \
                              sh_coroutine(command11))

    four, five, six, seven, eight, nine, ten, eleven = loop.run_until_complete(commands)
    loop.close()

    command12 = '/home/qicoo/qicoo-ansible/bat/sg-all-down.sh'
    command13 = ansible_ctl + '/home/qicoo/qicoo-ansible/aws/delete-ebs-prometheus.yml'
    twelve = sh_exec(command12)
    thirteen = sh_exec(command13)

    stdoutlist = [one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve, thirteen]
    with open(log_file_path,'w') as f:
        for stdout in stdoutlist:
            f.write(stdout)

if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    async_ansible_down(loop)
