{{- if .Values.enabled }}{{- if .Values.automountServiceAccountToken.enabled }}
{{- $namespaces := .Values.automountServiceAccountToken.namespaces | default (list) }}
{{- $namespaces := concat $namespaces .Values.global.namespaces }}
{{- $excludedNamespaces := .Values.automountServiceAccountToken.excludedNamespaces | default (list) }}
{{- $excludedNamespaces := concat $excludedNamespaces .Values.global.excludedNamespaces }}
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sPSPAutomountServiceAccountTokenPod
metadata:
  name: psp-automount-serviceaccount-token-pod
spec:
  {{- if .Values.automountServiceAccountToken.dryRun }}
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
{{- end }}{{- end }}