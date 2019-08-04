#!/usr/bin/env bash

if ! [ -x "$(command -v python3)" ]; then
  echo 'Python3 not installed. Installing it first' >&2
  sudo yum install python3 -y
fi


if ! [ -x "$(command -v pip3)" ]; then
  echo 'Pip not installed. Installing it first' >&2
  sudo yum install python3-pip -y
fi

if ! [ -x "$(command -v packer)" ]; then
  echo 'Pip not isntalled. Installing it first' >&2
  sudo yum install packer -y
fi


sudo pip3 install -r requirements.txt
#ansible-galaxy install -r requirements.yml -c -p playbooks/roles --force

# Calculating BUILD_NUMBER to add in version while creating AMI
BUILD_NUMBER=$(git ls-remote https://github.com/ThoughtWorksInc/infra-problem.git HEAD | awk '{print $1}' | cut -c1-7)
VERSION=$(date +%Y%m%d-%H%M)

# Below lines to create AMI for each server
# Could optimize this by running the packer command in parallel
/usr/bin/packer build \
  -var "version=$VERSION-$BUILD_NUMBER" \
  ./frontend.json

/usr/bin/packer build \
  -var "version=$VERSION-$BUILD_NUMBER" \
  ./newsfeed.json

/usr/bin/packer build \
  -var "version=$VERSION-$BUILD_NUMBER" \
  ./quotesfeed.json

# Echoing version build number to add in terraform variables file
echo "$VERSION-$BUILD_NUMBER"
