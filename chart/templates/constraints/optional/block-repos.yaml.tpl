{{- if .Values.enabled }}{{- if .Values.disallowedRepos.enabled }}
{{- $namespaces := .Values.disallowedRepos.namespaces | default (list) }}
{{- $namespaces = concat $namespaces .Values.global.namespaces }}
{{- $excludedNamespaces := .Values.disallowedRepos.excludedNamespaces | default (list) }}
{{- $excludedNamespaces = concat $excludedNamespaces .Values.global.excludedNamespaces }}
{{- $repos := .Values.disallowedRepos.repos | default (list) }}
{{- if not (empty $repos) }}
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sDisallowedRepos
metadata:
  name: repo-must-not-be-k8s-gcr-io
spec:
  {{- if .Values.disallowedRepos.dryRun }}
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
    repos:
      {{- range $repos }}
      - {{ . | quote }}
      {{- end }}
{{- end }}
{{- end }}{{- end }}