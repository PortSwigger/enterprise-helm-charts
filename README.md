# enterprise-helm-charts

Helm charts for Burp Suite DAST Kubernetes installation.

# Usage

The command ```helm repo add bsee https://portswigger.github.io/enterprise-helm-charts/``` can be used to add the repo.

The helm chart in this repository can then be installed using the following command:

```shell
helm install ${RELEASE_NAME} bsee/burp-suite-enterprise-edition \
   --set database.url=${DATABASE_URL} \
   --set database.enterpriseServerUsername=${DATABASE_ENTERPRISE_SERVER_USERNAME} \
   --set database.enterpriseServerConnectionUsername=${DATABASE_ENTERPRISE_SERVER_CONNECTION_USERNAME} \
   --set database.enterpriseServerPassword=${DATABASE_ENTERPRISE_SERVER_PASSWORD} \
   --set database.scanningResourceUsername=${DATABASE_SCANNING_RESOURCE_USERNAME} \
   --set database.scanningResourceConnectionUsername=${DATABASE_SCANNING_RESOURCE_CONNECTION_USERNAME} \
   --set database.scanningResourcePassword=${DATABASE_SCANNING_RESOURCE_PASSWORD}
```

Where ```enterpriseServerConnectionUsername``` and ```scanningResourceConnectionUsername``` are optional.

More information about custom values can be found in [getting started](https://portswigger.net/burp/documentation/enterprise/getting-started/kubernetes/new-deployment/install-app#providing-custom-values-for-the-helm-chart) documentation.

## Existing Helm installations

The defaults retain the EKS security settings, chart-managed Secrets, keystore init containers, web-server RollingUpdate strategy and namespace LimitRange. Upgrades using `--reuse-values` also retain these defaults when the new settings are absent. Helm reuses existing generated passwords and shared keys through `lookup`; it generates a value only when the Secret or required key is missing. Helm needs permission to read those Secrets: an API or permission error fails the operation rather than silently generating replacements.

Partial external Secrets are supported for normal Helm installations. Offline rendering, including ArgoCD's Helm rendering, cannot read the existing Secrets. Supplying only the scanning or relay Secret still leaves randomly generated server passwords. Repeated renders can then change the password without rerunning the keystore init container, causing a server to fail after its application container restarts.

## External Secrets and GitOps

For ArgoCD, set `gitOps.enabled: true` and supply all four external Secret names. This mode rejects incomplete configuration before rendering workloads. Create the Secrets in the release namespace before starting the workloads; the chart references them and does not create them.

| Setting | Required Secret keys |
| --- | --- |
| `scanningSharedSecret.existingSecret` | `BSEE_HOSTED_SCANNING_MACHINE_API_KEY` |
| `relaySharedSecret.existingSecret` | `RELAY_SECRET` and `BSEE_REQUEST_RELAY_SECRET`, with identical values |
| `services.enterpriseServer.existingSecret` | `BSEE_HTTPS_KEYSTORE_PASSWORD`, `BSEE_ADMIN_REPOSITORY_USERNAME`, `BSEE_ADMIN_REPOSITORY_PASSWORD`, `BSEE_AGENT_REPOSITORY_USERNAME`, `BSEE_AGENT_REPOSITORY_PASSWORD` |
| `services.webServer.existingSecret` | `BSEE_CLIENT_KEYSTORE_PASSWORD` and `BSEE_CLIENT_TRUSTSTORE_PASSWORD`, with identical values |

The enterprise-server Secret may also contain `BSEE_ADMIN_REPOSITORY_CONNECTION_USERNAME` and `BSEE_AGENT_REPOSITORY_CONNECTION_USERNAME` where the connection username differs from the internal username. With this Secret configured, the `database.*` username and password values are ignored; continue to supply `database.url` in the values file.

External keystore and truststore passwords must contain only ASCII letters and digits and be at least six characters long; use at least 20 characters for new passwords. The init containers validate these constraints before modifying a keystore. The restriction accommodates the current `createKeystore` script and does not apply to database passwords or the separately configured web HTTPS certificate passphrase.

For example, a GitOps values file can use:

```yaml
gitOps:
  enabled: true
scanningSharedSecret:
  existingSecret: dast-scanning-v1
relaySharedSecret:
  existingSecret: dast-relay-v1
services:
  enterpriseServer:
    existingSecret: dast-enterprise-v1
  webServer:
    existingSecret: dast-web-v1
    strategy: Recreate
database:
  url: jdbc:postgresql://database:5432/dast
```

When migrating an existing installation, copy its current passwords, shared keys and database credentials into the external Secrets to preserve authentication. Use new Secret names: stopping chart management of a generated Secret can delete it during Helm upgrade or ArgoCD pruning, so reusing its name requires a separate ownership migration.

## Security settings and LimitRange

The deployment and init-container security contexts are configurable through `podSecurityContext` and `containerSecurityContext`. Set individual fields to `null` to remove the EKS defaults where the platform assigns its own UID and group. Scanner Jobs have separate `scanner.podSecurityContext` and `scanner.containerSecurityContext` settings; both default to empty maps, preserving existing scanner behavior.

For a platform that assigns UIDs and manages namespace limits, the following can be combined with the GitOps example and adjusted to its security policy:

```yaml
podSecurityContext:
  runAsUser: null
  runAsGroup: null
  fsGroup: null
  fsGroupChangePolicy: null
containerSecurityContext:
  runAsUser: null
scanner:
  podSecurityContext:
    seccompProfile:
      type: RuntimeDefault
  containerSecurityContext:
    allowPrivilegeEscalation: false
    capabilities:
      drop:
        - ALL
limitRange:
  enabled: false
```

Changing configured scanner security contexts replaces scan-controller so it loads the updated Job template. The settings apply to newly created scanner Jobs; existing Jobs are unchanged. These examples require validation against the target cluster's security and storage policies.

## Secret changes and rollback

Changing the contents of an external Secret alone does not replace Pods. Prefer versioned, immutable Secrets: create new Secrets, update their `existingSecret` names in the same values change, and retain the old Secrets until their Pods and any affected scans have finished. A changed Secret reference replaces the corresponding deployment Pods. Shared-key rotation must be coordinated with running scans and the components using those keys.

If keeping fixed Secret names, update a pod annotation along with the Secret change to replace all four deployment Pods:

```yaml
podAnnotations:
  secrets-version: "2"
```

This annotation is a revision chosen by the operator; the chart does not detect external Secret content changes. Updating a mutable server Secret before Pod replacement can briefly leave an application using a new password with an old keystore. Versioned Secrets avoid that mismatch in an existing Pod.

Keep keystore generation in the init containers so an application-container restart does not regenerate its keys. For keystore-password rotations, set `services.webServer.strategy: Recreate` to avoid overlapping web Pods writing the same keystore on shared storage. Enterprise-server already uses Recreate. This does not change the default web-server strategy for existing installations.

For Helm-managed releases, `helm rollback RELEASE REVISION` restores an earlier release's manifests. For an ArgoCD application, revert the Git change and sync it. Neither restores externally managed Secret contents, database changes or PVC contents. Retain compatible previous Secret versions and coordinate their restoration with Pod replacement; keystore init containers run when replacement Pods start.

All available settings and their defaults are listed in the [chart README](charts/helm-chart/README.md).
