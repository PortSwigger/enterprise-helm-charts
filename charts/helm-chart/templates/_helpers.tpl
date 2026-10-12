{{- define "recommended-labels" -}}
app.kubernetes.io/part-of: {{ .Values.applicationName }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}

{{- define "ingress-label" -}}
{{ .Values.services.webServer.label }}
{{- end -}}

{{- define "bsee-container-registry-env" -}}
{{- if .Values.containerRegistry }}
- name: BSEE_CONTAINER_REGISTRY
  value: {{ .Values.containerRegistry }}
{{- end }}
{{- end -}}

{{- define "container-registry" -}}
{{- if .Values.containerRegistry }}
{{- .Values.containerRegistry -}}/
{{- end }}
{{- end -}}

{{- define "image-pull-secrets" -}}
{{- if .Values.imagePullSecrets -}}
imagePullSecrets:
{{ toYaml .Values.imagePullSecrets }}
{{- end -}}
{{- end -}}

{{- define "image-tag" -}}
{{- .Chart.AppVersion -}}
{{- end -}}

{{- define "enterprise-server-image" -}}
{{ include "container-registry" . }}portswigger/enterprise-server:{{ include "image-tag" . }}
{{- end -}}

{{- define "web-server-image" -}}
{{ include "container-registry" . }}portswigger/web-server:{{ include "image-tag" . }}
{{- end -}}

{{- define "scan-controller-image" -}}
{{ include "container-registry" . }}portswigger/scan-controller:{{ include "image-tag" . }}
{{- end -}}

{{- define "portswigger-hosted-scan-image" -}}
{{ include "container-registry" . }}portswigger/portswigger-hosted-scan:{{ include "image-tag" . }}
{{- end -}}

{{- define "relay-image" -}}
{{ include "container-registry" . }}portswigger/relay:{{ include "image-tag" . }}
{{- end -}}

{{- define "kebabcase-release-name" -}}
{{- kebabcase .Release.Name | replace " " "-" | replace "." "-" | replace "_" "-" -}}
{{- end -}}

{{- define "screaming-snakecase-release-name" -}}
{{- snakecase .Release.Name | replace " " "_" | replace "." "_" | replace "-" "_" | upper -}}
{{- end -}}

{{- define "scanning-shared-secret-name" -}}
{{- (default dict .Values.scanningSharedSecret).existingSecret | default (printf "%s-scanning-shared-secret" (include "kebabcase-release-name" .)) -}}
{{- end -}}

{{- define "relay-shared-secret-name" -}}
{{- (default dict .Values.relaySharedSecret).existingSecret | default (printf "%s-relay-shared-secret" (include "kebabcase-release-name" .)) -}}
{{- end -}}

{{- define "enterprise-server-secret-name" -}}
{{- .Values.services.enterpriseServer.existingSecret | default (printf "%s-enterprise-server-secret" (include "kebabcase-release-name" .)) -}}
{{- end -}}

{{- define "web-server-secret-name" -}}
{{- .Values.services.webServer.existingSecret | default (printf "%s-web-server-secret" (include "kebabcase-release-name" .)) -}}
{{- end -}}

{{- define "secret-field-value" -}}
{{- $secret := lookup "v1" "Secret" .context.Release.Namespace .name | default dict -}}
{{- $data := get $secret "data" | default dict -}}
{{- $value := get $data .key -}}
{{- if $value -}}
{{- $value -}}
{{- else -}}
{{- randAlphaNum .length | b64enc -}}
{{- end -}}
{{- end -}}

{{- define "pod-annotations" -}}
{{- $annotations := mergeOverwrite (deepCopy .base) (default dict .context.Values.podAnnotations) -}}
{{- if $annotations -}}
annotations:
{{ toYaml $annotations | indent 2 }}
{{- end -}}
{{- end -}}

{{- define "validate-keystore-password" -}}
keystore_password=${{ . }}
case "$keystore_password" in
  ''|*[!A-Za-z0-9]*)
    echo "{{ . }} must contain only ASCII letters and digits." >&2
    exit 1
    ;;
esac
if [ "${#keystore_password}" -lt 6 ]; then
  echo "{{ . }} must contain at least six characters." >&2
  exit 1
fi
{{- end -}}

{{- define "security-context" -}}
{{- $defaults := dict
    "podSecurityContext" (dict "runAsUser" 42877 "runAsGroup" 42877 "fsGroup" 42877 "fsGroupChangePolicy" "OnRootMismatch")
    "containerSecurityContext" (dict "allowPrivilegeEscalation" false "runAsUser" 42877 "capabilities" (dict "drop" (list "ALL"))) -}}
{{- $values := get $defaults .field -}}
{{- if hasKey .context.Values .field -}}
{{- $values = get .context.Values .field | default dict -}}
{{- end -}}
{{- $merged := mergeOverwrite (deepCopy .base) $values -}}
{{- $nullKeys := list -}}
{{- range $key, $val := $merged -}}
{{- if kindIs "invalid" $val -}}
{{- $nullKeys = append $nullKeys $key -}}
{{- end -}}
{{- end -}}
{{- range $nullKeys -}}
{{- $_ := unset $merged . -}}
{{- end -}}
{{- toYaml $merged -}}
{{- end -}}
