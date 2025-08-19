{{- if .Values.enabled }}{{- if .Values.disruptionBudget.enabled }}
{{- $namespaces := .Values.disruptionBudget.namespaces | default (list) }}
{{- $namespaces = concat $namespaces .Values.global.namespaces }}
{{- $excludedNamespaces := .Values.disruptionBudget.excludedNamespaces | default (list) }}
{{- $excludedNamespaces = concat $excludedNamespaces .Values.global.excludedNamespaces }}
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sPodDisruptionBudget
metadata:
  name: pod-disruption-budget
  annotations:
    argocd.argoproj.io/sync-wave: "1"
spec:
  {{- if .Values.disruptionBudget.dryRun }}
  enforcementAction: warn
  {{- end }}
  match:
    kinds:
      - apiGroups: ["apps"]
        kinds: ["Deployment", "StatefulSet"]
      - apiGroups: ["policy"]
        kinds: ["PodDisruptionBudget"]
      - apiGroups: [""]
        kinds: ["ReplicationController"]
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
{{- end }}{{- end }}
