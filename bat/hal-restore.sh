#!/bin/bash

LAST_HAL_BACKUP+="/home/qicoo/hal-back/"
LAST_HAL_BACKUP+=$(ls -1t /home/qicoo/hal-back/ | grep halbackup- | head -n1)
hal backup restore --backup-path ${LAST_HAL_BACKUP}
hal config provider kubernetes account edit aws --kubeconfig-file /home/qicoo/.kube/config
hal config provider kubernetes account edit kubernetes-master --kubeconfig-file /home/qicoo/.kube/config
