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
   sleep 2
   echo "android,app"
   sleep 5
   echo "shell") | gitlab-ci-multi-runner register || die 'errored'

   # Create the record
   touch /home/gitlab-runner/.runned
fi

gitlab-ci-multi-runner run --working-directory=/home/gitlab-runner
