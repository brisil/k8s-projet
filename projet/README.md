## Installation

```bash
kubectl create namespace inventaire
kubectl label namespace inventaire pod-security.kubernetes.io/enforce=restricted pod-security.kubernetes.io/enforce-version=latest
kubectl -n inventaire create secret generic postgres-secret --from-literal=password="$(openssl rand -hex 16)"
```
