# Set variables
$clustername="myakscluster"
$rg="aksRG"
$subscriptionId=$env:azure_personal_subscriptionId

# Provider register: Register the Azure Policy provider
az provider register --namespace Microsoft.PolicyInsights

# Enable Azure policy add-on for AKS
az aks enable-addons --addons azure-policy --name $clustername --resource-group $rg

# Login to kubectl
az aks get-credentials --resource-group $rg --name $clustername --admin

# azure-policy pod is installed in kube-system namespace
kubectl get pods -n kube-system

# gatekeeper pod is installed in gatekeeper-system namespace
kubectl get pods -n gatekeeper-system

# Test if policy add-on is installed
az aks show --query addonProfiles.azurepolicy -g $rg -n $clustername

# Test elevated pod creation
kubectl apply -f nginx-privileged.yaml