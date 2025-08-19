{{- if .Values.enabled }}{{- if .Values.ingress.enforceUniqueHosts.enabled }}
{{- $namespaces := .Values.ingress.enforceUniqueHosts.namespaces | default (list) }}
{{- $namespaces = concat $namespaces .Values.global.namespaces }}
{{- $excludedNamespaces := .Values.ingress.enforceUniqueHosts.excludedNamespaces | default (list) }}
{{- $excludedNamespaces = concat $excludedNamespaces .Values.global.excludedNamespaces }}
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sUniqueTraefikIngressHost
metadata:
  name: unique-traefik-ingress-host
  annotations:
    argocd.argoproj.io/sync-wave: "1"
spec:
  {{- if .Values.ingress.enforceUniqueHosts.dryRun }}
  enforcementAction: warn
  {{- end }}
  match:
    kinds:
      - apiGroups: ["traefik.io"]
        kinds: ["IngressRoute"]
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