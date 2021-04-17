#!/bin/bash

VERSION=`sed '3!d' pubspec.yaml | sed -e "s/version: //g"`

docker build -t jacobmoura7/hasura-webhook-auth:$VERSION .
docker push jacobmoura7/hasura-webhook-auth:$VERSION