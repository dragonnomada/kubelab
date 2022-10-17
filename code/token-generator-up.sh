kubectl create -f token-generator-deploy.yaml

kubectl create -f token-generator-service-cluster-ip.yaml

echo "Cluster Monitor:"

kubectl get po,rs,deploy,svc,no,ep -A

