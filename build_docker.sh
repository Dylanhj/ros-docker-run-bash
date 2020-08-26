#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
docker build --build-arg your_name=${USER} -t hejie/slam -f ${DIR}/Dockerfile ${DIR}/..
