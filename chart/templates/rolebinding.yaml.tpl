apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: gatekeeper-update-namespace-label-rancher
rules:
- apiGroups:
  - management.cattle.io
  resources:
  - projects
  verbs:
  - updatepsa
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: gatekeeper-update-namespace-label-rancher
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: gatekeeper-update-namespace-label-rancher
subjects:
- kind: ServiceAccount
  name: gatekeeper-update-namespace-label
  namespace: gatekeeper