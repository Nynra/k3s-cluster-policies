{{- if .Values.enabled }}{{- if .Values.ephemeralStorageLimit.enabled }}
{{- $namespaces := .Values.ephemeralStorageLimit.namespaces | default (list) }}
{{- $namespaces = concat $namespaces .Values.global.namespaces }}
{{- $excludedNamespaces := .Values.ephemeralStorageLimit.excludedNamespaces | default (list) }}
{{- $excludedNamespaces = concat $excludedNamespaces .Values.global.excludedNamespaces }}
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sContainerEphemeralStorageLimit
metadata:
  name: container-ephemeral-storage-limit
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
    ephemeral-storage: {{ .Values.ephemeralStorageLimit.size | default "1Gi" | quote }}
{{- end }}{{- end }}