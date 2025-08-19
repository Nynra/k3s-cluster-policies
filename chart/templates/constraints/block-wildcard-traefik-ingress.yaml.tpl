{{- if .Values.enabled }}{{- if .Values.ingress.blockWildcardIngress.enabled }}
{{- $namespaces := .Values.ingress.blockWildcardIngress.namespaces | default (list) }}
{{- $namespaces := concat $namespaces .Values.global.namespaces }}
{{- $excludedNamespaces := .Values.ingress.blockWildcardIngress.excludedNamespaces | default (list) }}
{{- $excludedNamespaces := concat $excludedNamespaces .Values.global.excludedNamespaces }}
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sBlockWildcardTraefikIngress
metadata:
  name: block-wildcard-traefik-ingress
spec:
  {{- if .Values.ingress.blockWildcardIngress.dryRun }}
  enforcementAction: warn
  {{- end }}
  match:
    kinds:
      - apiGroups: ["extensions", "networking.k8s.io"]
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