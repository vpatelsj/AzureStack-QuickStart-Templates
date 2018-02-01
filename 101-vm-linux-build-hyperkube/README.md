# Kubernetes Build Machine
This template deploys a Ubuntu 16.04 virtual machine on AzureStack, builds kubernetes and hyperkube images and pushes the hyperkube image to dockerhub

## Prerequisites
Follow the below links to create/download an Ubuntu 16.04 LTS Image and upload the same to Azure Stack's Platform Image Repository(PIR)
1. https://azure.microsoft.com/en-us/documentation/articles/azure-stack-linux/
2. https://azure.microsoft.com/en-us/documentation/articles/azure-stack-add-image-pir/
	Note: please use the default values for linuxPublisher,linuxOffer,linuxSku,linuxVersion found in azuredeploy.json while creating the manifest.json in PIR

## Deploying from Portal
``` diff
+ Running into issues? Check out FAQ section for known issues/workarounds.
```
+	Login into Azurestack portal
+	Click "New" -> "Custom" -> "Template deployment -> "Edit Template" -> "Load File" -> Select azure.deploy.json from the local drive -> "Save"
+ Click "Edit Parameters" and 	Fill the parameters. Please note down the admin name and password for later use
+	Select "Create new" to create new Resource Group and give a new resource group name
+	Click "Create"
+ Wait until the template deployment is completed

## Deploying from PowerShell

Download azuredeploy.json and azuredeploy.azurestack.parameters.json to local machine 

Modify parameter value in azuredeploy.parameters.json as needed 

Allow cookies in IE: Open IE at c:\Program Files\Internet Explorer\iexplore.exe -> Internet Options -> Privacy -> Advanced -> Click OK -> Click OK again

Launch a PowerShell console

Change working folder to the folder containing this template

```PowerShell

# Add specific Azure Stack Environment 

Add-AzureRmEnvironment -Name "AzureStackUser" -ArmEndpoint "https://management.local.azurestack.external"
$TenantID = Get-AzsDirectoryTenantId -AADTenantName "YOUR_AAD_TENANT_NAME" -EnvironmentName AzureStackUser
$UserName='YOUR_AZs_TENANT_USER_NAME'
$Password='YOUR_AZs_TENANT_PASSWORD'| ConvertTo-SecureString -Force -AsPlainText
$Credential= New-Object PSCredential($UserName,$Password)
Login-AzureRmAccount -EnvironmentName "AzureStackUser" -TenantId $TenantID -Credential $Credential 
Select-AzureRmSubscription -SubscriptionId "YOUR_SUBSCRIPTION_ID"

$resourceGroupName = "minikuberg"
$resourceGroupDeploymentName = "$($resourceGroupName)Deployment"

# Create a resource group:
New-AzureRmResourceGroup -Name $resourceGroupName -Location "local"

# Deploy template to resource group: Deploy using a local template and parameter file
New-AzureRmResourceGroupDeployment  -Name $resourceGroupDeploymentName -ResourceGroupName $resourceGroupName `
                                    -TemplateFile "LOCAL_PATH_TO azuredeploy.json" `
                                    -TemplateParameterFile "LOCAL_PATH_TO azuredeploy.parameters.json" -Verbose


```