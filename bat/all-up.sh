#!/bin/bash

ANSIBLE_CTL="ansible-playbook -i localhost, -c local"

${ANSIBLE_CTL} eks/setup-eks-env.yml
${ANSIBLE_CTL} aws/create-rds-instance.yml
${ANSIBLE_CTL} aws/create-elasticache-cluster.yml
${ANSIBLE_CTL} ark/create-heptio-deployment.yml
${ANSIBLE_CTL} ark/create-heptio-restore.yml
hal deploy apply
