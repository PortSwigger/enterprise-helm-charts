# burp-suite-enterprise-edition

![Version: 2026.10.1](https://img.shields.io/badge/Version-2026.10.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 2026.10-31570](https://img.shields.io/badge/AppVersion-2026.10--31570-informational?style=flat-square)

A Helm chart to deploy Burp Suite DAST on a Kubernetes cluster. See the release notes at https://portswigger.net/burp/releases/dast-2026-10.

**Homepage:** <https://portswigger.net/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Portswigger | <support@portswigger.net> |  |

## Source Code

* <https://github.com/portswigger/enterprise-helm-charts/>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| applicationName | string | `"bsee"` |  |
| containerRegistry | string | `"public.ecr.aws"` | The container registry used to get the DAST images |
| containerSecurityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsUser":42877}` | Container-level securityContext for DAST deployments and their init containers. Set a field to null to remove it. See podSecurityContext before removing runAsUser. |
| database.enterpriseServerConnectionUsername | string | `""` | Connection username for the DAST Server database connection. Required if connection username differs from internal username e.g. if @hostname suffix is mandated (Azure) |
| database.enterpriseServerPassword | string | `""` | Password for the DAST Server database connection |
| database.enterpriseServerUsername | string | `""` | Username for the DAST Server database connection |
| database.idleTimeout | int | `60000` | Idle timeout (ms) for the database connection |
| database.maxLifetimeTimeout | int | `120000` | Maximum lifetime timeout (ms) for the database connection |
| database.scanningResourceConnectionUsername | string | `""` | Connection username for the Scanning Resource database connection Required if connection username differs from internal username e.g. if @hostname suffix is mandated (Azure) |
| database.scanningResourcePassword | string | `""` | Password for the Scanning Resource database connection |
| database.scanningResourceUsername | string | `""` | Username for the Scanning Resource database connection |
| database.url | string | `""` | JDBC connection URL for the database |
| defaultCpuPerContainer | string | `"100m"` |  |
| defaultMemoryPerContainer | string | `"128Mi"` |  |
| defaultRequestCpuPerContainer | string | `"100m"` |  |
| defaultRequestMemoryPerContainer | string | `"128Mi"` |  |
| enterpriseServerContainerCpu | string | `"1400m"` |  |
| enterpriseServerContainerMemory | string | `"4Gi"` |  |
| gitOps.enabled | bool | `false` | Require all four existingSecret settings to avoid random Secrets during offline rendering. |
| imagePullSecrets | list | `[]` |  |
| limitRange.enabled | bool | `true` | Create the LimitRange for the DAST namespace. Set to false where LimitRanges are managed centrally. |
| maxCpuPerContainer | string | `"4"` |  |
| maxMemoryPerContainer | string | `"8Gi"` |  |
| minCpuPerContainer | string | `"100m"` |  |
| minMemoryPerContainer | string | `"128Mi"` |  |
| persistentVolumeClaim | string | `"bsee-pvc"` | Name of the persistent volume claim used for shared storage between the DAST Pods |
| podAnnotations | object | `{}` | Annotations added to all DAST deployment Pods. Change a Secret-version annotation to replace Pods after updating a Secret. |
| podSecurityContext | object | `{"fsGroup":42877,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":42877,"runAsUser":42877}` | Pod-level securityContext for all DAST deployments. Set a field to null to remove it. Only remove runAsUser where the platform assigns a numeric user, such as OpenShift. Elsewhere, set a different numeric ID. connection-relay and scan-controller also set runAsNonRoot: true, which cannot start without a numeric user. To remove it, set runAsNonRoot to null here and in containerSecurityContext. |
| relaySharedSecret.existingSecret | string | `""` | Name of an existing Secret containing the keys RELAY_SECRET and BSEE_REQUEST_RELAY_SECRET, both set to the same value. When set, the chart does not create or regenerate the relay shared secret. |
| scanContainerCpu | string | `"1400m"` |  |
| scanContainerMemory | string | `"8Gi"` |  |
| scanControllerCpu | string | `"500m"` |  |
| scanControllerMemory | string | `"512Mi"` |  |
| scanner.containerSecurityContext | object | `{}` | Container-level securityContext for scanner Jobs. |
| scanner.podSecurityContext | object | `{}` | Pod-level securityContext for scanner Jobs. |
| scanningSharedSecret.existingSecret | string | `""` | Name of an existing Secret containing the key BSEE_HOSTED_SCANNING_MACHINE_API_KEY. When set, the chart does not create or regenerate the scanning shared secret. |
| services.enterpriseServer.existingSecret | string | `""` | Existing Secret to use instead of the chart-managed DAST server Secret. Must contain BSEE_HTTPS_KEYSTORE_PASSWORD, BSEE_ADMIN_REPOSITORY_* and BSEE_AGENT_REPOSITORY_* (optionally *_CONNECTION_USERNAME). The database.* username/password values are ignored when set. Keystore password: ASCII letters and digits only, at least six characters. |
| services.enterpriseServer.installationEnvironment | string | `"KUBERNETES"` |  |
| services.webServer.annotations | object | `{}` | Annotations added to the web-server Service, e.g. cloud load-balancer annotations |
| services.webServer.existingSecret | string | `""` | Existing Secret to use instead of the chart-managed web server Secret. Must contain BSEE_CLIENT_KEYSTORE_PASSWORD and BSEE_CLIENT_TRUSTSTORE_PASSWORD. Keystore passwords must match and use only ASCII letters and digits (minimum six characters). |
| services.webServer.httpPort | string | `"8080"` |  |
| services.webServer.httpsCertificateSecret.key | string | `"certificate"` |  |
| services.webServer.httpsCertificateSecret.name | string | `"bsee-web-server-https"` |  |
| services.webServer.httpsPassphraseSecret.key | string | `"passphrase"` |  |
| services.webServer.httpsPassphraseSecret.name | string | `"bsee-web-server-https"` |  |
| services.webServer.httpsPort | string | `"8443"` |  |
| services.webServer.installationEnvironment | string | `"KUBERNETES"` |  |
| services.webServer.label | string | `"app.portswigger.net/ingress: web-server"` |  |
| services.webServer.strategy | string | `""` | Web-server deployment strategy. Empty retains RollingUpdate; use Recreate for keystore password rotations. |
| services.webServer.type | string | `""` | Kubernetes Service type for the web-server Service ("ClusterIP", "LoadBalancer" or "NodePort"). Uses the cluster default (ClusterIP) when unset. |
| services.webServer.useHttps | bool | `false` |  |
| webServerContainerCpu | string | `"1400m"` |  |
| webServerContainerMemory | string | `"4Gi"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
