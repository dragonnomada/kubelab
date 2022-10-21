echo "INSTALANDO KUBECTL..."

sudo snap install kubectl --classic

kubectl version --output yaml

echo "INSTALANDO KIND..."

wget https://github.com/kubernetes-sigs/kind/releases/download/v0.16.0/kind-linux-amd64

sudo chmod +x kind-linux-amd64

sudo cp kind-linux-amd64 /usr/local/bin/kind

sudo rm kind-linux-amd64

echo "GENERANDO CLUSTER 101"

kind create cluster --config - <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: cluster101

networking:
  apiServerAddress: "0.0.0.0"
  apiServerPort: 6443
  serviceSubnet: "10.96.0.0/12"
  podSubnet: "10.244.0.0/16"
  disableDefaultCNI: FALSE
  # kubeProxyMode: "ipvs"

nodes:
  - role: control-plane
  - role: worker
  - role: worker
EOF

echo "CREANDO USUARIO ADMINISTRATIVO..."

kubectl create -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-cluster
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-cluster
subjects:
  - kind: ServiceAccount
    name: admin-cluster
    namespace: default
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
EOF

echo "TOKEN DEL USUARIO ADMINISTRATIVO..."

kubectl create token admin-cluster

echo "MONTANDO EL DASHBOARD EN https:/0.0.0.0:3000..."

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.6.1/aio/deploy/recommended.yaml

kubectl wait --namespace kubernetes-dashboard \
  --for=condition=ready pod \
  --selector=k8s-app=kubernetes-dashboard \
  --timeout=600s

kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 3000:443 --address=0.0.0.0

echo "FELICIDADES YA TIENES TU DASHBOARD DE KUBERNETES 😎"