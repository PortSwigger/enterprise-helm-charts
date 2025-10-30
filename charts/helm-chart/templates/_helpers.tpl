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