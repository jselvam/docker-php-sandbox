#!/usr/bin/env bash
docker build  -t local/centos7 -f Dockerfile-centos7 .
docker build  -t  buydomains-ci4-img -f Dockerfile .