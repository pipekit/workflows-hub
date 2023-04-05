[![Pipekit Logo](assets/pipekit-logo.png)](https://pipekit.io)

# workflows-hub
A place to access, share and reference Pipekit-certified Argo WorkflowTemplates, Connectors and Examples.



## Installation

To apply a single workflowTemplate, you can simply run `kubectl apply -f <file>`


# Testing
## Running the tests locally
This will create a local k3d instance with Argo Workflows and prerequisites installed.
It'll then iterate through all tests and will output the result.
```
cd ci
./setup.sh
```

Run `k3d cluster delete hub-ci` when complete.

## Test development
### Prerequisites
A number of pre-requisite applications are available in the cluster to aid in testing:

- Argo workflows is configured with minio as an artifact repository. The bucket is called `workflows`.
- An insecure container registry is available at `docker-registry.hub.svc.cluster.local:5000`

### Adding Tests
The label `workflows.argoproj.io/test: "true"` must be added to any workflow that you want to use as a test, as well as any extra manifests required (for example a mounted secret).
