#!/bin/bash

if which rocker > /dev/null; then
  rocker --nvidia --x11 --pulse --name ros-on-docker-with-xrdp-and-audio --shm-size 1g --port 3389:3389 $(cat ./IMAGE_TAG)
else
  docker run -d --name ros-on-docker-with-xrdp-and-audio --shm-size 1g -p 3389:3389 $(cat ./IMAGE_TAG)
fi
