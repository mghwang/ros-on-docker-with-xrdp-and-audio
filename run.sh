#!/bin/bash

docker run -d --name ros-on-docker-with-xrdp-and-audio --shm-size 1g -p 3389:3389 $(cat ./IMAGE_TAG)
