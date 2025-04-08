# enterprise-helm-charts

Helm charts for BSEE Kubernetes installation.
Currently only contains the standard kubernetes BSEE installation helm chart.

## Usage

The command ```helm repo add bsee https://portswigger.github.io/enterprise-helm-charts/``` can be used to add the repo.

The helm chart in this repository can then be installed using the following command:

```shell
helm install ${RELEASE_NAME} bsee/burp-suite-enterprise-edition \
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
