{{- if .Values.enabled }}{{- if .Values.replicaLimits.enabled }}
{{- $namespaces := .Values.replicaLimits.namespaces | default (list) }}
{{- $namespaces = concat $namespaces .Values.global.namespaces }}
{{- $excludedNamespaces := .Values.replicaLimits.excludedNamespaces | default (list) }}
{{- $excludedNamespaces = concat $excludedNamespaces .Values.global.excludedNamespaces }}
{{- $min_replicas := .Values.replicaLimits.min_replicas }}
{{- $max_replicas := .Values.replicaLimits.max_replicas }}
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sReplicaLimits
metadata:
  name: replica-limits
spec:
  {{- if .Values.allowedRepos.dryRun }}
  enforcementAction: warn
  {{- end }}
  match:
    kinds:
      - apiGroups: ["apps"]
        kinds: ["Deployment"]
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
    ranges:
    - min_replicas: {{ $min_replicas | default 1 }}
      max_replicas: {{ $max_replicas | default 5 }}
{{- end }}{{- end }}