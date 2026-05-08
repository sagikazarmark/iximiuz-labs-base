#!/usr/bin/env bash
set -uo pipefail

exitCode=0

echo "Checking cluster info..."
if ! kubectl cluster-info; then
    echo "kube-apiserver is unavailable"
    exit 1
fi

echo "Waiting for nodes to be ready..."
if ! kubectl wait --for=condition=Ready nodes --all --timeout=45s; then
    echo "Nodes are not ready"
    exit 1
fi

echo "Creating podinfo deployment..."
if ! kubectl create deployment podinfo --image=ghcr.io/stefanprodan/podinfo --port=9898; then
    echo "Failed to create deployment"
    exit 1
fi

echo "Exposing the deployment..."
if ! kubectl expose deployment podinfo --port=9898; then
    echo "Failed to expose deployment"
    exitCode=1
fi

echo "Waiting for pod to be ready..."
if ! kubectl wait --for=condition=Ready pods --all --timeout=45s; then
    echo "Pod failed to become ready within timeout"
    exit 1
fi

echo "Checking which node the pod runs on..."
POD_NAME=$(kubectl get pods -l app=podinfo -o jsonpath='{.items[0].metadata.name}')
NODE_NAME=$(kubectl get pod $POD_NAME -o jsonpath='{.spec.nodeName}')
echo "Pod $POD_NAME is running on node: $NODE_NAME"

echo "Getting Pod IP and Service IP..."
POD_IP=$(kubectl get pod $POD_NAME -o jsonpath='{.status.podIP}')
SERVICE_IP=$(kubectl get service podinfo -o jsonpath='{.spec.clusterIP}')
echo "Pod IP: $POD_IP"
echo "Service IP: $SERVICE_IP"

echo "Testing connectivity from node $NODE_NAME..."

echo "Testing Pod IP connectivity..."
if ! ssh -o StrictHostKeyChecking=no $NODE_NAME "curl -sf http://$POD_IP:9898/healthz" < /dev/null | grep -q "OK"; then
    echo "Pod IP connectivity test failed"
    exitCode=1
fi

echo "Testing Service IP connectivity..."
if ! ssh -o StrictHostKeyChecking=no $NODE_NAME "curl -sf http://$SERVICE_IP:9898/healthz" < /dev/null | grep -q "OK"; then
    echo "Service IP connectivity test failed"
    exitCode=1
fi

exit $exitCode
