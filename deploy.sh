#!/bin/bash
set -e

echo "Ensuring minikube ingress addon is enabled..."
minikube addons enable ingress

echo "Building and Pushing the latest image to Docker Hub..."
./push.sh

echo "Applying Kubernetes manifests..."
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml

echo "Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=60s deployment/node-api-deployment -n node-api-ns

echo "Deployment complete! You can access the API via minikube's IP."
MINIKUBE_IP=$(minikube ip)
echo "Run this to test the API route: curl http://$MINIKUBE_IP/"
echo "Run this to test the health route: curl http://$MINIKUBE_IP/health"

echo ""
echo "================================================="
echo "Forwarding traffic to http://localhost:3000"
echo "Keep this terminal open! (Press Ctrl+C to stop)"
echo "================================================="
kubectl port-forward svc/node-api-service 3000:80 -n node-api-ns
