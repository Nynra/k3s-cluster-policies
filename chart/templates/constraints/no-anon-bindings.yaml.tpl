{{- if .Values.enabled }}{{- if .Values.noAnonymousRoleBindings.enabled }}
{{- $namespaces := .Values.noAnonymousRoleBindings.namespaces | default (list) }}
{{- $namespaces = concat $namespaces .Values.global.namespaces }}
{{- $excludedNamespaces := .Values.noAnonymousRoleBindings.excludedNamespaces | default (list) }}
{{- $excludedNamespaces = concat $excludedNamespaces .Values.global.excludedNamespaces }}
{{- $allowedRoles := .Values.noAnonymousRoleBindings.allowedRoles | default (list) }}
{{- $allowedClusterRoles := .Values.noAnonymousRoleBindings.allowedClusterRoles | default (list) }}
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sDisallowAnonymous
metadata:
  name: no-anonymous
  annotations:
    argocd.argoproj.io/sync-wave: "1"
spec:
  {{- if .Values.allowedRepos.dryRun }}
  enforcementAction: warn
  {{- end }}
  match:
    kinds:
      - apiGroups: ["rbac.authorization.k8s.io"]
        kinds: ["ClusterRoleBinding"]
      - apiGroups: ["rbac.authorization.k8s.io"]
        kinds: ["RoleBinding"]
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
    {{- if not (empty $allowedRoles) }}
    allowedRoles:
      {{- range $allowedRoles }}
      - {{ . | quote }}
      {{- end }}
    {{- end }}
    {{- if not (empty $allowedClusterRoles) }}
    allowedClusterRoles:
      {{- range $allowedClusterRoles }}
      - {{ . | quote }}
      {{- end }}
    {{- end }}
{{- end }}{{- end }}