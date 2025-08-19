{{- if .Values.enabled }}{{- if .Values.blockNodePorts.enabled }}
{{- $namespaces := .Values.blockNodePorts.namespaces | default (list) }}
{{- $namespaces = concat $namespaces .Values.global.namespaces }}
{{- $excludedNamespaces := .Values.blockNodePorts.excludedNamespaces | default (list) }}
{{- $excludedNamespaces = concat $excludedNamespaces .Values.global.excludedNamespaces }}
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sBlockNodePort
metadata:
  name: block-node-port
  annotations:
    argocd.argoproj.io/sync-wave: "1"
spec:
  {{- if .Values.blockNodePorts.dryRun }}
  enforcementAction: warn
  {{- end }}
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Service"]
    {{- if not (empty $namespaces) }}
    namespaces:
      {{- toYaml $namespaces | nindent 8 }}
    {{- end }}
    {{- if not (empty $excludedNamespaces) }}
    excludedNamespaces:
      {{- toYaml $excludedNamespaces | nindent 8 }}
    {{- end }}
{{- end }}{{- end }}