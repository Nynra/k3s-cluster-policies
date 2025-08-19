apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: "{{ .Release.Name }}-network-policies"
  namespace: {{ .Release.Namespace | quote }}
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
        - podSelector: {}
    - from:
        - namespaceSelector: {}
      ports:
        - port: 8888
  egress:
    - to:
        - namespaceSelector: {}
          podSelector:
            matchLabels:
              k8s-app: kube-dns
      ports:
        - port: 53
          protocol: UDP
    - to:
        - podSelector: {}
