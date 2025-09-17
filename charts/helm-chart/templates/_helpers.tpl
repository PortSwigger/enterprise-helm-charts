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

{{- define "ephemeral-agent-image" -}}
{{ include "container-registry" . }}portswigger/ephemeral-agent:{{ include "image-tag" . }}
{{- end -}}

{{- define "kebabcase-release-name" -}}
{{- kebabcase .Release.Name | replace " " "-" | replace "." "-" | replace "_" "-" -}}
{{- end -}}

{{- define "screaming-snakecase-release-name" -}}
{{- snakecase .Release.Name | replace " " "_" | replace "." "_" | replace "-" "_" | upper -}}
{{- end -}}

{{- define "tolerations" -}}
{{- if .Values.tolerations }}
tolerations:
{{- range .Values.tolerations }}
  - key: "{{ .key }}"
    operator: "{{ .operator }}"
    value: "{{ .value }}"
    effect: "{{ .effect }}"
{{- end }}
{{- end }}
{{- end -}}

{{- define "nodeAffinity" -}}
{{- if .Values.nodeAffinity }}
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        {{- range .Values.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.nodeSelectorTerms }}
        - matchExpressions:
            {{- range .matchExpressions }}
            - key: {{ .key }}
              operator: {{ .operator }}
              values:
                {{ toYaml .values  }}
            {{- end }}
        {{- end }}
{{- end }}
{{- end -}}