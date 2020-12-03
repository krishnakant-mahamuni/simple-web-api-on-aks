#az login

ACCOUNT_JSON=$(az account show -o json)

TENANT_ID=$(echo $ACCOUNT_JSON | jq -r '.tenantId')
SUBSCRIPTION_ID=$(echo $ACCOUNT_JSON | jq -r '.id')

echo $TENANT_ID
echo $SUBSCRIPTION_ID

SERVICE_PRINCIPAL_JSON=$(az ad sp create-for-rbac --skip-assignment --name aks-simple-web-api-sp -o json)
SERVICE_PRINCIPAL=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.appId')
SERVICE_PRINCIPAL_SECRET=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.password')

az role assignment create --assignee $SERVICE_PRINCIPAL \
--scope "/subscriptions/$SUBSCRIPTION_ID" \
--role Contributor

#Create storage account to store the tfstate

az group create -l australiaeast -n tfstate-rg
az storage account create -n aetfstate001sa -g tfstate-rg -l australiaeast --sku Standard_LRS
az storage container create -n tfstate --account-name aetfstate001sa --resource-group tfstate-rg