{{- if .Values.enabled }}{{- if .Values.blockLatestImageTag.enabled }}
{{- $namespaces := .Values.blockLatestImageTag.namespaces | default (list) }}
{{- $namespaces = concat $namespaces .Values.global.namespaces }}
{{- $excludedNamespaces := .Values.blockLatestImageTag.excludedNamespaces | default (list) }}
{{- $excludedNamespaces = concat $excludedNamespaces .Values.global.excludedNamespaces }}
{{- $tags := .Values.blockLatestImageTag.tags | default (list) }}
{{- $exemptImages := .Values.blockLatestImageTag.exemptImages | default (list) }}
{{- if not (empty $tags) | not (empty $exemptImages) }}
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sDisallowedTags
metadata:
  name: container-image-must-not-have-latest-tag
spec:
  {{- if .Values.blockLatestImageTag.dryRun }}
  enforcementAction: warn
  {{- end }}
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
    {{- if not (empty $namespaces) }}
    namespaces:
      {{- range $namespaces }}
      - {{ . | quote }}
      {{- end }}
    {{- end }}
    {{- if not (empty $excludedNamespaces) }}
    excludedNamespaces:
      {{- range $excludedNamespaces }}
      - {{ . | quote }}
      {{- end }}
    {{- end }}
  parameters:
    tags:
      - "latest"
    {{- if not (empty $exemptImages) }}
    exemptImages:
      {{- range $exemptImages }}
      - {{ . | quote }}
      {{- end }}
    {{- end }}
{{- end }}
{{- end }}{{- end }}