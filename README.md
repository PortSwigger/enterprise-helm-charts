# enterprise-helm-charts

Helm charts for BSEE Kubernetes installation. 
Currently only contains the standard kubernetes BSEE installation helm chart.

# Usage

## From a fork

This repository can be forked and modified however you please.

The command ```helm repo add bsee <GITHUB PAGES URL>``` can be used to add the repo.

The helm chart in this repository can then be installed using the following command if you have updated the database configuration:

```shell
helm install --set appVersion=<ENTERPRISE VERSION> <INTERNAL NAME> bsee/burp-suite-enterprise-edition
```

An example of this command might be ```helm install --set appVersion=2023.9-14019 bsee bsee/burp-suite-enterprise-edition```.

The published versions of enterprise can be found in the [Amazon Elastic Container Registry](https://gallery.ecr.aws/portswigger/enterprise-server) under the "Image tags" tab.

## Directly from the repository

The command ```helm repo add bsee https://portswigger.github.io/enterprise-helm-charts/``` can be used to add the repo.

The helm chart in this repository can then be installed using the following command:

```shell
helm install bsee/burp-suite-enterprise-edition <INTERNAL NAME> \
   --set appVersion=<ENTERPRISE VERSION> \
   --set database.url=${DATABASE_URL} \
   --set database.enterpriseServerUsername=${DATABASE_ENTERPRISE_SERVER_USERNAME} \
   --set database.enterpriseServerConnectionUsername=${DATABASE_ENTERPRISE_SERVER_CONNECTION_USERNAME} \
   --set database.enterpriseServerPassword=${DATABASE_ENTERPRISE_SERVER_PASSWORD} \
   --set database.scanningResourceUsername=${DATABASE_SCANNING_RESOURCE_USERNAME} \
   --set database.scanningResourceConnectionUsername=${DATABASE_SCANNING_RESOURCE_CONNECTION_USERNAME}
   --set database.scanningResourcePassword=${DATABASE_SCANNING_RESOURCE_PASSWORD}
```

Where ```enterpriseServerConnectionUsername``` and ```scanningResourceConnectionUsername``` are optional.

More information about custom values can be found in [getting started](https://portswigger.net/burp/documentation/enterprise/getting-started/kubernetes/new-deployment/install-app#providing-custom-values-for-the-helm-chart) documentation.

The published versions of enterprise can be found in the [Amazon Elastic Container Registry](https://gallery.ecr.aws/portswigger/enterprise-server) under the "Image tags" tab.


