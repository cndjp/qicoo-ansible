#!/bin/bash
source /home/qicoo/qicoo-ansible/bat/env
EKSSCALE_LOG_DIR="/home/qicoo/qicoo-bot-scale/"

EKSSCALE_LOG_FILE+=${EKSSCALE_LOG_DIR}
EKSSCALE_LOG_FILE+=${1}
NODE_GROUPS=`/home/qicoo/.local/bin/aws cloudformation describe-stack-resources --stack-name spinnaker-eks-nodes --query 'StackResources[?LogicalResourceId==\`NodeGroup\`].PhysicalResourceId' --output text`
SCALE_NUM=${2}

${ANSIBLE_CTL} /home/qicoo/qicoo-ansible/eks/scale-eks-nodes.yml --extra-vars "scale_num=${SCALE_NUM}" > ${EKSSCALE_LOG_FILE}
/home/qicoo/.local/bin/aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names ${NODE_GROUPS} --output table >> ${EKSSCALE_LOG_FILE}
