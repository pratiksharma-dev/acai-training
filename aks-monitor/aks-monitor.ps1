# Set variables
$clustername="myakscluster"
$clusterrg="aksRG"
$subscriptionId=$env:azure_personal_subscriptionId
$workspacerg="defaultresourcegroup-eus"
$workspace="DefaultWorkspace-$subcriptionId-EUS"

# Enable container insights on aks cluster
az aks enable-addons -a monitoring -n $clustername -g $clusterrg --workspace-resource-id "/subscriptions/$subscriptionId/resourceGroups/$workspacerg/providers/Microsoft.OperationalInsights/workspaces/$workspace"