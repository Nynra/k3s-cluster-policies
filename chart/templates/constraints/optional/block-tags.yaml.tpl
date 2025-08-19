{{- if .Values.enabled }}{{- if .Values.disallowedTags.enabled }}
{{- $namespaces := .Values.disallowedTags.namespaces | default (list) }}
{{- $namespaces = concat $namespaces .Values.global.namespaces }}
{{- $excludedNamespaces := .Values.disallowedTags.excludedNamespaces | default (list) }}
{{- $excludedNamespaces = concat $excludedNamespaces .Values.global.excludedNamespaces }}
{{- $tags := .Values.disallowedTags.tags | default (list) }}
{{- $exemptImages := .Values.disallowedTags.exemptImages | default (list) }}
{{- if not (empty $tags) | not (empty $exemptImages) }}
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sDisallowedTags
metadata:
  name: container-image-must-not-have-latest-tag
spec:
  {{- if .Values.allowedRepos.dryRun }}
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
    {{- if not (empty $tags) }}
    tags:
      {{- range $tags }}
      - {{ . | quote }}
      {{- end }}
    {{- end }}
    {{- if not (empty $exemptImages) }}
    exemptImages:
      {{- range $exemptImages }}
      - {{ . | quote }}
      {{- end }}
    {{- end }}
{{- end }}
{{- end }}{{- end }}