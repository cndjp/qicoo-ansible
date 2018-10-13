#!/bin/bash

python files/get-pip.py --user
echo 'PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
echo 'alias a="ansible-playbook -i localhost, -c local"' >> ~/.bashrc
pip install --user ansible
