# Install chocolatey (Run as admin in PowerShell)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Helm using Chocolatey on Windows (Restart PowerShell first)
choco install kubernetes-helm
helm version

# Set kubectl context
az login
az account set -s "Personal Subscription"
az aks get-credentials --resource-group aksRG --name myakscluster --admin
# Create Helm chart
helm create myapp2
helm install myapp-demo .\myapp2
kubectl get deployments
$POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=myapp2,app.kubernetes.io/instance=myapp-demo" -o jsonpath="{.items[0].metadata.name}")
echo $POD_NAME
$CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
echo $CONTAINER_PORT
kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT
echo "Visit http://127.0.0.1:8080 to use your application"

# Install directly from repo
helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo bitnami
helm install nginx-demo bitnami/nginx
kubectl get deployments