## Summary

## Inputs

## Outputs

## Install
`kubectl apply -f https://raw.githubusercontent.com/pipekit/workflows-hub/main/workflowTemplates/container-build-kaniko/workflowTempalte.yaml`




Something about Kaniko secret:
  volumes:
  - name: docker-config
    secret:
      secretName: docker-config
      items:
        - key: .dockerconfigjson
          path: config.json
