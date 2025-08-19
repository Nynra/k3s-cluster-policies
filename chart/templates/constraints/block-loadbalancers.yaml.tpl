{{- if .Values.enabled }}{{- if .Values.blockLoadBalancerServices.enabled }}
{{- $namespaces := .Values.blockLoadBalancerServices.namespaces | default (list) }}
{{- $namespaces := concat $namespaces .Values.global.namespaces }}
{{- $excludedNamespaces := .Values.blockLoadBalancerServices.excludedNamespaces | default (list) }}
{{- $excludedNamespaces := concat $excludedNamespaces .Values.global.excludedNamespaces }}
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sBlockLoadBalancer
metadata:
  name: block-load-balancer
  annotations:
    argocd.argoproj.io/sync-wave: "1"
spec:
  {{- if .Values.blockLoadBalancerServices.dryRun }}
  enforcementAction: warn
  {{- end }}
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Service"]
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
