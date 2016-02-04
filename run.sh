#!/bin/bash

export ANDROID_HOME=/opt/android-sdk

if [ ! -f /home/gitlab-runner/.runned ]; then
  # First run!
  # We have to register to the CI now.
  (echo "${GITLAB_CI_URL}"
   sleep 2
   echo "${GITLAB_CI_TOKEN}"
   sleep 2
   echo "${GITLAB_CI_DESC}"
   sleep 10
   echo "shell") | gitlab-ci-multi-runner register
fi

gitlab-ci-multi-runner --user=gitlab-runner --working-directory=/home/gitlab-runner
