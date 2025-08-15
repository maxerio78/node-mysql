#!/usr/bin/env bash
set -euo pipefail

NS="${K8S_NAMESPACE:-default}"
DEPLOY="${DEPLOYMENT_FILE:-k8s/deployment.yaml}"
SVC="${SERVICE_FILE:-}"

echo "Namespace: $NS"
echo "Deployment file: $DEPLOY"
echo "Service file: ${SVC:-<none>}"

if kubectl get deployment node-mysql-deployment -n "$NS" >/dev/null 2>&1; then
  echo "Deployment found. Updating image..."
  CONTAINER_NAME=$(kubectl get deployment node-mysql-deployment -n "$NS" -o jsonpath='{.spec.template.spec.containers[0].name}')
  if [ -z "$CONTAINER_NAME" ]; then
    echo "No container name found in deployment spec"
    exit 1
  fi
  kubectl set image deployment/node-mysql-deployment ${CONTAINER_NAME}=$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG -n "$NS" --record
else
  echo "Deployment not found. Applying manifests..."
  if [ ! -f "$DEPLOY" ]; then
    echo "Deployment file $DEPLOY not found"
    exit 1
  fi
  kubectl apply -f "$DEPLOY" -n "$NS"
  if [ -n "$SVC" ] && [ -f "$SVC" ]; then
    kubectl apply -f "$SVC" -n "$NS"
  fi
fi

echo "Waiting for rollout..."
kubectl rollout status deployment/node-mysql-deployment -n "$NS"
