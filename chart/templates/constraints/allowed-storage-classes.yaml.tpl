{{- if .Values.enabled }}{{- if .Values.allowedStorageClasses.enabled }}
{{- $namespaces := .Values.allowedStorageClasses.namespaces | default (list) }}
{{- $namespaces := concat $namespaces .Values.global.namespaces }}
{{- $excludedNamespaces := .Values.allowedStorageClasses.excludedNamespaces | default (list) }}
{{- $excludedNamespaces := concat $excludedNamespaces .Values.global.excludedNamespaces }}
{{- $storageClasses := .Values.allowedStorageClasses.storageClasses | default (list) }}
{{- if not (empty $storageClasses) }}
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sStorageClass
metadata:
  name: allowed-storageclass
  annotations:
    argocd.argoproj.io/sync-wave: "1"
spec:
  {{- if .Values.allowedStorageClasses.dryRun }}
  enforcementAction: warn
  {{- end }}
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["PersistentVolumeClaim"]
      - apiGroups: ["apps"]
        kinds: ["StatefulSet"]
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
    includeStorageClassesInMessage: {{ .Values.allowedStorageClasses.includeStorageClassesInMessage }}
    allowedStorageClasses:
      {{- range $storageClasses }}
      - {{ . | quote }}
      {{- end }}
{{- end }}
{{- end }}{{- end }}