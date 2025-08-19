{{- if .Values.enabled }}{{- if .Values.allowedRepos.enabled }}
{{- $namespaces := .Values.allowedRepos.namespaces | default (list) }}
{{- $namespaces := concat $namespaces .Values.global.namespaces }}
{{- $excludedNamespaces := .Values.allowedRepos.excludedNamespaces | default (list) }}
{{- $excludedNamespaces := concat $excludedNamespaces .Values.global.excludedNamespaces }}
{{- $repos := .Values.allowedRepos.repos | default (list) }}
{{- if not (empty $repos) }}
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sAllowedReposv2
metadata:
  name: repos-has-allowed-prefix 
  annotations:
    argocd.argoproj.io/sync-wave: "1"
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
    allowedImages:
      {{- range $repos }}
      - {{ . | quote }}
      {{- end }}
{{- end }}

{{- end }}{{- end }}