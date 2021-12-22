#!/usr/bin/env bash

set -x
CWD="$(pwd)"
echo $CWD

cd PropertyFiles/PropertyFiles
tar zxvf properties-artifacts.tar.gz

export pod=$(kubectl -n zb-config get po -o json| jq .items[0].metadata.name|sed 's/"//g')


if [ $# -lt 1 ];then
  echo "No arguments found"
  echo "Usage: copyPropertyFileintoPod.sh Environment(DEV|NONPROD|PROD)"
  exit 1
fi

ENV=$1

echo Running kubectl cp on all files
for file in *-"$ENV".properties;do
  echo $file
  kubectl -n zb-config cp $file $pod:configfiles/systemConfiguration
done
