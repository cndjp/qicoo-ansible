#!/bin/bash

ANSIBLE_CTL="ansible-playbook -i localhost, -c local"

${ANSIBLE_CTL} ark/create-heptio-backup.yml
${ANSIBLE_CTL} eks/delete-eks-env.yml
${ANSIBLE_CTL} aws/delete-rds-instance.yml
${ANSIBLE_CTL} aws/delete-elasticache-cluster.yml
${ANSIBLE_CTL} ark/delete-heptio-deployment.yml
