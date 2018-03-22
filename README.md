# concourse-fiaas-resource

[![License:MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/leboncoin/concourse-fiaas-resource/blob/master/LICENSE)
[![Build Status](https://travis-ci.org/leboncoin/concourse-fiaas-resource.svg?branch=master)](https://travis-ci.org/leboncoin/concourse-fiaas-resource)
[![Maintainability](https://api.codeclimate.com/v1/badges/54dc93906670fe7591f0/maintainability)](https://codeclimate.com/github/leboncoin/concourse-fiaas-resource/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/54dc93906670fe7591f0/test_coverage)](https://codeclimate.com/github/leboncoin/concourse-fiaas-resource/test_coverage)
 
A Concourse CI resource for FIAAS deployment.

[FIAAS](https://github.com/fiaas) *(Finn Infrastructure As A Service)* is a contract driven continuous delivery to Kubernetes. Supports CRE and on premise.

More information about FIAAS [here](http://schd.ws/hosted_files/cloudnativeeu2017/ff/finn-no-kubecon.pdf).

## Source Configuration
All these parameters are **required** but can be set in the `resource` *(source)* or `put` *(out)* definition.

* `uri`: The base URI of the FIAAS server (with prefix: `http`/`https`).
* `application_name`: Name of the application to deploy.
* `namespace`: Namespace where deploy the application.

## Behavior
### `check`
Currently, the `check` script returns the latest version or an empty version (`{ }`).

### `get`
Currently, the `get` script only return version number and metadata parameters following the `put` script execution.

### `put` - Deploy an application with FIAAS
The `put` script will try to deploy a new version of the application based on given parameters with FIAAS service.

The **required** parameters are the same as the ones in `source` section with two more (`config_url` & `image`).


* `uri`: The base URI of the FIAAS server (with prefix: `http`/`https`).
* `application_name`: Name of the application to deploy.
* `config_url`: Path of file which contains the URL of the FIAAS configuration file (should be a valid yaml file).
* `image`: Path of file which contains the URL of the Docker Image on a Docker Registry.
* `namespace`: Namespace where deploy the application.

**CAUTION**: `config_url` & `image` require a path file, not a string.

## Example:

```yaml
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
  - get: my_resource
  - put: fiaas-staging
    params:
      application_name: my_app
      config_url: my_resource/config
      image: my_resource/docker_image
  - put: fiaas-prod
    params:
      application_name: my_app
      config_url: my_resource/config
      image: my_resource/docker_image
```
### Acknowledgement:

Thanks to Jose Riguera (jose.riguera@springernature.com) from the Python resource class.
