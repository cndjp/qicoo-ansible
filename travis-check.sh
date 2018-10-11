#!/bin/bash

ARY=(ark aws cli)

for DIR in ${ARY[@]}; do
  for FILE in `\find ${DIR} -maxdepth 1 -type f -name "*.yml"`; do
    ansible-playbook -i localhost, -c local ${FILE} --syntax-check
  done
done

$TRAVIS_BUILD_DIR/cli/git-secrets/git-secrets --register-aws --global
$TRAVIS_BUILD_DIR/cli/git-secrets/git-secrets --scan . 
