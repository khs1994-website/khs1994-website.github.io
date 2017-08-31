#!/bin/bash

# Decrypt the private key
#openssl aes-256-cbc -K $encrypted_73c7cac50e50_key -iv $encrypted_73c7cac50e50_iv -in .travis/id_rsa.enc -out ~/.ssh/id_rsa -d
# Set the permission of the key
#chmod 600 ~/.ssh/id_rsa
# Start SSH agent
#eval $(ssh-agent)
# Add the private key to the system
#ssh-add ~/.ssh/id_rsa
# Copy SSH config
#cp .travis/ssh_config ~/.ssh/config
# Set Git config
#git config --global user.name "khs1994"
#git config --global user.email "khs1994@khs1994.com"
# Clone the repository
git ls-files | while read file; do touch -d $(git log -1 --format="@%ct" "$file") "$file"; done
docker run -dit -v $PWD:/tmp/gitbook-src khs1994/gitbook
docker ps -a
function main()
{
  docker ps -l | grep Exited
  if [ $? = 0 ];then
    #已经退出
    echo -e "\033[31mINFO\033[0m  Docker has STOP"
  else
    sleep 1s
    echo -e "\033[32mINFO\033[0m  Docker is RUNING..."
    main
  fi
}
main
pwd
git clone -b "$DEPLOY_BRANCH" "$REPO" .deploy_git
if [ ! $? = 0 ];then
  #不存在
  echo -e "\033[31mINFO\033[0m  BRANCH $DEPLOY_BRANCH NOT exist"
  mkdir .deploy_git
  cd .deploy_git
  git init
  git remote add origin $REPO
  git checkout -b "$DEPLOY_BRANCH"
  cd ..
else
  #存在
  echo -e "\033[32mINFO\033[0m  BRANCH exist"
  rm -rf .deploy_git/*
fi
# Deploy to GitHub and aliyun
cp -r _book/* .deploy_git/
cd .deploy_git
git remote add aliyun "$REPO_ALIYUN"
git add .
COMMIT=`date "+%F %T"`
git commit -m "Travis CI Site updated: $COMMIT"
git push -f aliyun "$DEPLOY_BRANCH"
git push -f origin "$DEPLOY_BRANCH"
cd ~
sudo rm -rf repo
