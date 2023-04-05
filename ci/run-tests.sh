#!/usr/bin/env bash
set -eu -o pipefail

kubectl config set-context --current --namespace=hub

grep -lR 'workflows.argoproj.io/template' ../workflowTemplates/* | while read f ; do
  kubectl create -f $f
done

trap 'kubectl get wf' EXIT

grep -lR 'workflows.argoproj.io/test' ../workflowTemplates/* | while read f ; do
  kubectl delete workflow -l workflows.argoproj.io/test
  kubectl delete secret -l workflows.argoproj.io/test
  echo "Running $f..."
  kubectl create -f $f
  name=$(kubectl get workflow -o name)
  kubectl wait --for=condition=Completed $name --timeout=3m
  phase="$(kubectl get $name -o 'jsonpath={.status.phase}')"
  echo " -> $phase"
  test Succeeded == $phase
done

grep -lR 'workflows.argoproj.io/template' ../workflowTemplates/* | while read f ; do
  kubectl delete all -l workflows.argoproj.io/template
done
