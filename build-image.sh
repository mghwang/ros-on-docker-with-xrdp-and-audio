#!/bin/bash

read -p "Enter the default user id : " userId
read -s -p "Enter the password for user $userId : " userPasswd

INPUT_HASH=`echo $userId $userPasswd | openssl md5`

TMPFILE=`mktemp /tmp/XXXXXX`
echo "$userPasswd" >> $TMPFILE
trap "rm -f $TMPFILE" EXIT

docker build --platform linux/amd64 -t $(cat ./IMAGE_TAG) --build-arg "DEFAULT_USER=$userId" --build-arg "INPUT_HASH=$INPUT_HASH" --secret "id=defaultUserPasswd,src=$TMPFILE" .

