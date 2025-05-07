# dast-helm-charts

Helm charts for Burp Suite DAST Kubernetes installation.

# Enterprise to DAST Rebrand update

This repository has been updated to reflect the rebranding of Burp Suite Enterprise Edition to Burp Suite DAST.
The helm chart name has been changed from `burp-suite-enterprise` to `burp-suite-dast`.

Installation instructions updated to accommodate moved repo with new GitHub pages link 
`https://portswigger.github.io/dast-helm-charts/`

Default variables `applicationName` and `persistentVolumeClaim` will be renamed from 
`bsee` and `bsee-pvc` to `dast` and `dast-pvc` respectively.

# Usage

The command ```helm repo add dast https://portswigger.github.io/dast-helm-charts/``` can be used to add the repo.

The helm chart in this repository can then be installed using the following command:

```shell
helm install ${RELEASE_NAME} dast/burp-suite-dast \
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

