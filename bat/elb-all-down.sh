#!/bin/bash

LB_LIST=(`aws elb describe-load-balancers | jq -r '.LoadBalancerDescriptions[].LoadBalancerName'`)
for((i=0; i<${#LB_LIST[@]}; i++))
do
  aws elb delete-load-balancer --load-balancer-name ${LB_LIST[i]}
done
