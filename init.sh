#!/bin/bash

python files/get-pip.py --user
echo 'PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
echo 'alias a="ansible-playbook -i localhost, -c local"' >> ~/.bashrc
echo 'export KUBECONFIG=~/.kube/config' >> ~/.bashrc
pip install --user ansible
pip install --user boto3 slackbot
sudo apt-get install -y jq git
