#!/bin/bash

docker build -t myfoxit/multi-client:latest -t myfoxit/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t myfoxit/multi-server:latest -t myfoxit/multi-server:$SHA  -f ./server/Dockerfile ./server
docker build -t myfoxit/multi-worker:latest  -t myfoxit/multi-worker:$SHA -f ./worker/Dockerfile ./worker
docker push myfoxit/multi-client:latest
docker push myfoxit/multi-server:latest
docker push myfoxit/multi-worker:latest

docker push myfoxit/multi-client:$SHA
docker push myfoxit/multi-server:$SHA
docker push myfoxit/multi-worker:$SHA


kubectl apply -f k8s
kubectl set image deployments/server-deployment server=myfoxit/multi-server:$SHA
kubectl set image deployments/client-deployment client=myfoxit/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=myfoxit/multi-worker:$SHA
