{{- define "recommended-labels" -}}
app.kubernetes.io/part-of: {{ .Values.applicationName }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Values.appVersion }}
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

{{- define "image-tag" -}}
{{- .Values.appVersion -}}{{- if .Values.support.oracle -}}-oracle{{- end -}}
{{- end -}}

{{- define "enterprise-server-image" -}}
{{ include "container-registry" . }}portswigger/enterprise-server:{{ include "image-tag" . }}
{{- end -}}

{{- define "web-server-image" -}}
{{ include "container-registry" . }}portswigger/web-server:{{ include "image-tag" . }}
{{- end -}}

{{- define "ephemeral-agent-image" -}}
{{ include "container-registry" . }}portswigger/ephemeral-agent:{{ include "image-tag" . }}
{{- end -}}

{{- define "kebabcase-release-name" -}}
{{- kebabcase .Release.Name | replace " " "-" | replace "." "-" | replace "_" "-" -}}
{{- end -}}

{{- define "screaming-snakecase-release-name" -}}
{{- snakecase .Release.Name | replace " " "_" | replace "." "_" | replace "-" "_" | upper -}}
{{- end -}}