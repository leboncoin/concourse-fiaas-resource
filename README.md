# concourse-fiaas-resource
A Concourse CI resource for FIAAS deployment.

## Source Configuration
All these parameters are **required** but can be set in the `resource` *(source)* or `put` *(out)* definition.

* `uri`: The base URI of the FIAAS server (with prefix: `http`/`https`).
* `application_name`: Name of the application to deploy.
* `config_url`: URL of the FIAAS configuration file (should be a valid yaml file).
* `image`: URL of the Docker Image on a Docker Registry.
* `namespace`: Namespace where deploy the application.

## Behavior
### `check`
Currently, the `check` script returns the latest version or an empty version (`{ }`).

### `get`
Currently, the `get` script only return version number and metadata parameters following the `put` script execution.

### `put` - Deploy an application with FIAAS
The `put` script will try to deploy a new version of the application based on given parameters with FIAAS service.

The **required** parameters are  the same as the ones in `source` section and can be set in the `resource` *(source)* or `put` *(out)* definition.

* `uri`: The base URI of the FIAAS server (with prefix: `http`/`https`).
* `application_name`: Name of the application to deploy.
* `config_url`: URL of the FIAAS configuration file (should be a valid yaml file).
* `image`: URL of the Docker Image on a Docker Registry.
* `namespace`: Namespace where deploy the application.

## Example:

With all parameters in `resource` section:

```
---
resource_types:
- name: fiaas
  type: docker-image
  source:
    repository: leboncoin/concourse-fiaas-resource

resources:
- name: fiaas-k8s-cluster
  type: fiaas
  source:
    uri: http://foo.bar
    application_name: my_app
    config_url: http://foo.bar/my_app-1.00.yaml
    image: http://my-docker-registry.com/my_app:my_app-1.00
    namespace: production

jobs:
- name: my-fiaas-deployment
  plan:
  - put: fiaas-k8s-cluster
  [...]
```

With parameters in `resource` and `put` sections:   
(**Example:** With staging and production resources)
```
---
resource_types:
- name: fiaas
  type: docker-image
  source:
    repository: leboncoin/concourse-fiaas-resource

resources:
- name: fiaas-staging
  type: fiaas
  source:
    uri: http://foo-prod.bar
    namespace: production  
- name: fiaas-prod
  type: fiaas
  source:
    uri: http://foo-staging.bar
    namespace: staging

jobs:
- name: my-fiaas-deployment
  plan:
  - put: fiaas-staging
    params:
      application_name: my_app
      config_url: http://foo.bar/my_app-1.00-dev-123.yaml
      image: http://my-docker-registry.com/my_app:my_app-1.00-dev-123
  - put: fiaas-prod
    params:
      application_name: my_app
      config_url: http://foo.bar/my_app-1.00.yaml
      image: http://my-docker-registry.com/my_app:my_app-1.00      
```
### Acknowledgement:

Thanks to Jose Riguera (jose.riguera@springernature.com) from the Python resource class.
