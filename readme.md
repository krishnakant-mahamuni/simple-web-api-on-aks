## Login to Azure

```
#login and follow prompts
az login 
    TENTANT_ID=<your-tenant-id>    

# view and select your subscription account

az account list -o table
SUBSCRIPTION=<id>
az account set --subscription $SUBSCRIPTION

```

## Create Service Principal

Kubernetes needs a service account to manage our Kubernetes cluster </br>
Lets create one! </br>

```

SERVICE_PRINCIPAL_JSON=$(az ad sp create-for-rbac --skip-assignment --name aks-simple-web-api-sp -o json)

# Keep the `appId` and `password` for later use!

SERVICE_PRINCIPAL=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.appId')
SERVICE_PRINCIPAL_SECRET=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.password')

#note: reset the credential if you have any sinlge or double quote on password
az ad sp credential reset --name "aks-simple-web-api-sp"

# Grant contributor role over the subscription to our service principal

az role assignment create --assignee $SERVICE_PRINCIPAL \
--scope "/subscriptions/$SUBSCRIPTION" \
--role Contributor

SERVICE_PRINCIPAL_JSON=$(az ad sp credential reset --name "aks-simple-web-api-sp" -o json)
SERVICE_PRINCIPAL=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.appId')
SERVICE_PRINCIPAL_SECRET=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.password')

```
For extra reference you can also take a look at the Microsoft Docs: [here](https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/aks/kubernetes-service-principal.md) </br>


# Terraform CLI
```
# Get Terraform

curl -o /tmp/terraform.zip -LO https://releases.hashicorp.com/terraform/0.12.28/terraform_0.12.28_linux_amd64.zip

unzip /tmp/terraform.zip
chmod +x terraform && mv terraform /usr/local/bin/

cd kubernetes/cloud/azure/terraform/

```

# Generate SSH key

```
ssh-keygen -t rsa -b 4096 -N "VeryStrongSecret007!" -C "kk.dev.ms@outlook.com" -q -f  ~/.ssh/id_rsa
SSH_KEY=$(cat ~/.ssh/id_rsa.pub)
```

## Terraform Azure Kubernetes Provider 

Documentation on all the Kubernetes fields for terraform [here](https://www.terraform.io/docs/providers/azurerm/r/kubernetes_cluster.html)

```
terraform init

terraform plan -var resource_group_name="simple-web-api-rg" \
    -var serviceprinciple_id="$SERVICE_PRINCIPAL" \
    -var serviceprinciple_key="$SERVICE_PRINCIPAL_SECRET" \
    -var subscription_id="$SUBSCRIPTION" \
    -var tenant_id="$TENANT_ID" \
    -var ssh_key="$SSH_KEY" \
    -var kubernetes_cluster_name="simple-web-api-aks" \
    -var sku="Standard"

terraform apply -var resource_group_name="simple-web-api-rg" \
    -var serviceprinciple_id="$SERVICE_PRINCIPAL" \
    -var serviceprinciple_key="$SERVICE_PRINCIPAL_SECRET" \
    -var tenant_id="$TENANT_ID" \
    -var subscription_id="$SUBSCRIPTION" \
    -var ssh_key="$SSH_KEY" \
    -var kubernetes_cluster_name="simple-web-api-aks" \
    -var sku="Standard" -auto-approve

terraform destroy -var resource_group_name="simple-web-api-rg" \
    -var serviceprinciple_id="$SERVICE_PRINCIPAL" \
    -var serviceprinciple_key="$SERVICE_PRINCIPAL_SECRET" \
    -var tenant_id="$TENANT_ID" \
    -var subscription_id="$SUBSCRIPTION" \
    -var ssh_key="$SSH_KEY" \
    -var kubernetes_cluster_name="simple-web-api-aks" 
    -var sku="Standard" -auto-approve
    
```

# Lets see what we deployed

```
# grab our AKS config
az aks get-credentials -n simple-web-api-aks -g simple-web-api-rg

# Get kubectl

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

kubectl get svc

```

# Clean up 

```
terraform destroy -var serviceprinciple_id=$SERVICE_PRINCIPAL \
    -var serviceprinciple_key="$SERVICE_PRINCIPAL_SECRET" \
    -var tenant_id=$TENTANT_ID \
    -var subscription_id=$SUBSCRIPTION \
    -var ssh_key="$SSH_KEY"
```

## Useful links and command

https://www.youtube.com/watch?v=ukmbiTSWU_M&list=UUCYR9GpcE3skVnyMU8Wx1kQ
https://www.youtube.com/watch?v=bHjS4xqwc9A


CI/CD
https://dev.azure.com/KKDevMS/
https://github.com/HoussemDellai/AzureDevOpsPipelines-Tips


docker tag <image_id> <tag>

sudo docker push <image>

sudo docker login <registry_name> --username <username> --password <password>