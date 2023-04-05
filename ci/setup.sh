#!/bin/bash

k3d cluster create --config k3d.conf

# Prevent users from accidentally deploying to the wrong cluster.
currentContext=$(kubectl config current-context)
if [ "$currentContext" == "k3d-hub-ci" ]; then
    echo "Starting deployment to cluster..."
else
    echo "The kubectl context is not what we expected. Exiting for safety. Perhaps the k3d cluster failed to create?"
    exit 1
fi

kubectl create namespace hub
kubectl config set-context --current --namespace=hub
kubectl -n kube-system rollout status deployment/metrics-server
kubectl apply -k argo-workflows-ns-install/
# kubectl apply -f pipekit-agent/
kubectl apply -f common-prerequisites/docker-registry/out.yaml
kubectl apply -f common-prerequisites/minio
kubectl apply -f common-prerequisites/nfs-server-provisioner/out.yaml


kubectl rollout status deployment/workflow-controller
kubectl rollout status deployment/argo-server
# kubectl rollout status deployment/pipekit-agent
kubectl rollout status deployment/docker-registry
kubectl rollout status deployment/minio
kubectl rollout status statefulset/nfs-server-provisioner

./run-tests.sh
