#!/bin/bash

LAST_HAL_BACKUP+="/home/qicoo/hal-back/"
LAST_HAL_BACKUP+=$(ls -1t /home/qicoo/hal-back/ | grep halbackup- | head -n1)
hal backup restore -q --backup-path ${LAST_HAL_BACKUP}
hal config provider kubernetes account edit aws -q --kubeconfig-file /home/qicoo/.kube/config
hal config provider kubernetes account edit kubernetes-master -q --kubeconfig-file /home/qicoo/.kube/config
