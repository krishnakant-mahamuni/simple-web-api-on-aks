## Tech Stack

```

1. Dotnet Core 5.0
2. Docker
3. Azure Cloud
4. Azure Pipelines
5. Azure CLI
6. Kubernetes
7. Terraform

```
## Resources Required

1. Azure Storage Account (used as backend for terraform)
2. Azure Kubernetes Service (Docker image will be deployed to this kubernetes instance)
3. Azure Container Registry (Docker image will be stored in this private registry to be pulled at the deployment stage)



### Login to Azure

```
    az login
    az account list -o table
    az account set --subscription <<SUBSCRIPTION_ID>>

    ACCOUNT_JSON=$(az account show -o json)
    SUBSCRIPTION_ID=$(echo ACCOUNT_JSON | jq -r 'id')
    TENANT_ID=$(echo ACCOUNT_JSON | jq -r 'tenantid')

```

### Create Service Principal

```

SERVICE_PRINCIPAL_JSON=$(az ad sp create-for-rbac --skip-assignment --name aks-simple-web-api-sp -o json)
SERVICE_PRINCIPAL=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.appId')
SERVICE_PRINCIPAL_SECRET=$(echo $SERVICE_PRINCIPAL_JSON | jq -r '.password')

az role assignment create --assignee $SERVICE_PRINCIPAL \
--scope "/subscriptions/$SUBSCRIPTION_ID" \
--role Contributor

```

### Create Terraform Backend

```

az group create -l <<location>> -n <<resource-group-name>>
az storage account create -n <<storage-account-name>> -g <<resource-group-name>> -l <<location>> --sku Standard_LRS
az storage container create -n <<container-name>> --account-name <<storage-account-name>> --resource-group <<resource-group-name>>

```

### Download Terraform CLI

```
# Get Terraform

curl -o /tmp/terraform.zip -LO https://releases.hashicorp.com/terraform/0.14.0/terraform_0.14.0_linux_amd64.zip

unzip /tmp/terraform.zip
chmod +x terraform && mv terraform /usr/local/bin/

```

### Configuring tfVars file in azure pipelines

```
In the cluster module there is a template for storing the secure credentials for creating the AKS cluster.

Create a separate file using the template and upload the same to the secure files in azure devops. Secure files can be located under Pipelines-> Library section. Upload the file and use the existing azurepipelines.yaml to configure the pipeline in azure devops. 


```

### Web API versioning approach

```
To version the API I have used "Microsoft.AspNetCore.Mvc.Versioning" nuget package. The package is configured to allow the users of the API 
to pass the api-version in the header. The APi will then check for the header values and if the proper values have been passed will return the response. 

```

## Testing the deployed API

```
The API can be tested using 

1. Postman tool 
2. CURL

e.g. curl -i -H "api-version: 1.0" -H "Content-Type: application/json" http://<<Load Balancer IP>>/version

``` 