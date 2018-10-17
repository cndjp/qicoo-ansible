#!/bin/bash

ARY=(ark aws cli eks)

for DIR in ${ARY[@]}; do
  for FILE in `\find ${DIR} -maxdepth 1 -type f -name "*.yml"`; do
    ansible-playbook -i localhost, -c local ${FILE} --syntax-check
  done
done

make install -C cli/git-secrets/ 
git secrets --register-aws --global
git secrets -r --scan . 

echo -e "\nCheck Done."
