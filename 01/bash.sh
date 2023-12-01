#!/bin/bash
NAME1=centos7
NAME2=ubuntu
NAME3=fedora
IMAGE1=pycontribs/centos:7
IMAGE2=pycontribs/ubuntu:latest
IMAGE3=pycontribs/fedora:latest

docker run -dit --name $NAME1 $IMAGE1
docker run -dit --name $NAME2 $IMAGE2
docker run -dit --name $NAME3 $IMAGE3

docker start $NAME1
docker start $NAME2
docker start $NAME3

ansible-playbook -i inventory/prod.yml site.yml --vault-password-file ~/password.txt

docker stop $NAME1
docker stop $NAME2
docker stop $NAME3
