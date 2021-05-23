# Set variables
$clustername="myakscluster"
$rg="aksRG"
$subscriptionId="daaad427-15a9-4542-9bdd-9d603751cab4"

# Create an AKS-managed Azure AD cluster with rbac and aad integration enabled
az aks create -g $rg -n $clustername --enable-aad --enable-azure-rbac

# Enable rbac for existing cluster
az aks update -g $rg -n $clustername --enable-azure-rbac

# Get your AKS Resource ID
$AKS_ID=$(az aks show -g $rg -n $clustername --query id -o tsv)

# Create RBAC role assignment for Cluster Admin
az role assignment create --role "Azure Kubernetes Service RBAC Admin" --assignee prashar@microsoft.com --scope $AKS_ID
az role assignment create --role "Azure Kubernetes Service RBAC Cluster Admin" --assignee prashar@microsoft.com --scope $AKS_ID
az role assignment list --scope $AKS_ID

# Create RBAC role assignment over namespace level
az role assignment create --role "Azure Kubernetes Service RBAC Reader" --assignee prashar@microsoft.com --scope $AKS_ID/namespaces/default

# Create custom RBAC role assignment
$rolejson=@"
{
    "Name": "AKS Deployment Reader",
    "Description": "Lets you view all deployments in cluster/namespace.",
    "Actions": [],
    "NotActions": [],
    "DataActions": [
        "Microsoft.ContainerService/managedClusters/apps/deployments/read"
    ],
    "NotDataActions": [],
    "assignableScopes": [
        "/subscriptions/$subscriptionId"
    ]
}
"@
Set-Content -Value $rolejson -Path .\customaksrole.json -Force
cmd /c "az role definition create --role-definition @customaksrole.json"
az role assignment create --role "AKS Deployment Reader" --assignee prashar@microsoft.com --scope "/subscriptions/$subscriptionId"
az role assignment list --role "AKS Deployment Reader"
