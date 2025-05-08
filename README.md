# 🏪 UDS Artifactory Zarf Package

[![Latest Release](https://img.shields.io/github/v/release/defenseunicorns/uds-package-artifactory)](https://github.com/defenseunicorns/uds-package-artifactory/releases)
[![Build Status](https://img.shields.io/github/actions/workflow/status/defenseunicorns/uds-package-artifactory/tag-and-release.yaml)](https://github.com/defenseunicorns/uds-package-artifactory/actions/workflows/tag-and-release.yaml)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/defenseunicorns/uds-package-artifactory/badge)](https://api.securityscorecards.dev/projects/github.com/defenseunicorns/uds-package-artifactory)

This package is designed to be deployed on [UDS Core](https://github.com/defenseunicorns/uds-core), and is based on the upstream [Artifactory](https://github.com/jfrog/charts/tree/master/stable/artifactory) chart.

## Pre-requisites

The Artifactory Package expects to be deployed on top of [UDS Core](https://github.com/defenseunicorns/uds-core) with the dependencies listed below being configured prior to deployment.

> [!IMPORTANT]
> **NOTE #1:** This package has been migrated to use Istio Ambient. Minimum version of uds-core required is `0.40.x`

> [!IMPORTANT]
> **NOTE #2**: Many features are locked behind a license. Some notable features include:
> - In place upgrades
> - Single sign-on capabilities

Artifactory is configured by default to assume the internal dependencies that are used for testing (see postgres in the [bundle](bundle/uds-bundle.yaml)).

#### Database

- A Postgres database is running on port `5432` and accessible to the cluster via the `ARTIFACTORY_DB_ENDPOINT` Zarf var.
- This database can be logged into via the username configured with the Zarf var `ARTIFACTORY_DB_USERNAME`. Default is `artifactory.artifactory`
- This database instance has a psql database created matching what is defined in the Zarf var `ARTIFACTORY_DB_NAME`. Default is `artifactorydb`
- The user has read/write access to the above mentioned database
- Create `artifactory-postgres` service in `artifactory` namespace that points to the psql database
- Create `artifactory-postgres` secret in `artifactory` namespace with the key `password` that contains the password to the user for the psql database

## Flavors

| Flavor | Description | Example Creation |
| ------ | ----------- | ---------------- |
| registry1 | Uses images from registry1.dso.mil within the package. | `zarf package create . -f registry1` |

> [!IMPORTANT]
> **NOTE:** To create the registry1 flavor you will need to be logged into Iron Bank - you can find instructions on how to do this in the [Big Bang Zarf Tutorial](https://docs.zarf.dev/tutorials/6-big-bang/#setup).

## Releases

The released packages can be found in [ghcr](https://github.com/defenseunicorns/uds-package-artifactory/pkgs/container/packages%2Fuds%2Fartifactory).

## UDS Tasks (for local dev and CI)

*For local dev, this requires you install [uds-cli](https://github.com/defenseunicorns/uds-cli?tab=readme-ov-file#install)

> [!TIP]
> To get a list of tasks to run you can use `uds run --list`!

## Redeploying/Upgrading pre-existing Artifactory

> [!IMPORTANT]
> **NOTE**: If admin credentials are changed or different from what is generated in the `artifactory-admin-credentials` secret, in the `values/common.yaml` set:

``` yaml
artifactory:
  admin:
    secret: ""
    dataKey: ""
```

The credentials will be reset to what is in the secret if not set to empty or might break the deployment/upgrade entirely.

## Contributing

Please see the [CONTRIBUTING.md](./CONTRIBUTING.md)
