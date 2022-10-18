#!/bin/bash

function now {
  echo $(date +%s)
}

start_time=$(now)
check_time=$(now)

function check {
  check_time=$(now)
  echo CHECK $1 ...
}

function complete {
  end=$(now)
  diff=$(( end - check_time ))
  echo COMPLETE in $(date -ud "@$diff" +'%M min %S sec')
}

function success {
  end=$(now)
  diff=$(( end - start_time ))
  echo SUCCESS in $(date -ud "@$diff" +'%M min %S sec')
}

echo "Working path:" $(pwd)

check "Removing all KinD clusters"

kind delete clusters --all

complete

check 'Creating KinD Cluster'

kind create cluster --name cluster202 --config cluster202.yaml

complete

check "Installing Calico (CNI)"

kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.1/manifests/calico.yaml

complete

check "Waiting for ready"

while [[ $(kubectl get po,rs,deploy,svc,no,ep -A | grep -P "pod/[^\s]+\s*0/\d+") ]]
do
  sleep 1
done

complete

echo "Cluster Monitor:"

kubectl get po,rs,deploy,svc,no,ep -A

success
