# Install chocolatey (Run as admin in PowerShell)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Helm using Chocolatey on Windows (Restart PowerShell first)
choco install kubernetes-helm
helm version

# Create Helm chart
helm create myapp
helm install myapp .\myapp
$POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=myapp,app.kubernetes.io/instance=myapp" -o jsonpath="{.items[0].metadata.name}")
$CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT
echo "Visit http://127.0.0.1:8080 to use your application"

# Install directly from repo
helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo bitnami
helm install nginx bitnami/nginx