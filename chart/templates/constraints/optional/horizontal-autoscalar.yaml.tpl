{{- if .Values.enabled }}{{- if .Values.horizontalPodAutoscaler.enabled }}
{{- $namespaces := .Values.horizontalPodAutoscaler.namespaces | default (list) }}
{{- $namespaces = concat $namespaces .Values.global.namespaces }}
{{- $excludedNamespaces := .Values.horizontalPodAutoscaler.excludedNamespaces | default (list) }}
{{- $excludedNamespaces = concat $excludedNamespaces .Values.global.excludedNamespaces }}
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sHorizontalPodAutoscaler
metadata:
  name: horizontal-pod-autoscaler
  annotations:
    argocd.argoproj.io/sync-wave: "1"
spec:
  {{- if .Values.allowedRepos.dryRun }}
  enforcementAction: warn
  {{- else }}
  enforcementAction: deny
  {{- end }}
  match:
    kinds:
      - apiGroups: ["autoscaling"]
        kinds: ["HorizontalPodAutoscaler"]
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
    minimumReplicaSpread: {{ .Values.horizontalPodAutoscaler.minimumReplicaSpread | default 1 }}
    enforceScaleTargetRef: {{ .Values.horizontalPodAutoscaler.enforceScaleTargetRef | default true }}
    ranges:
    - min_replicas: {{ .Values.horizontalPodAutoscaler.ranges.min_replicas | default 1 }}
      max_replicas: {{ .Values.horizontalPodAutoscaler.ranges.max_replicas | default 10 }}
{{- end }}{{- end }}