# Deploy in Azure ###################################################################################################################
# Login to your Azure account / subscription – this will prompt you with an interactive login.
Add-AzureRmAccount
$TenantID = "72f988bf-86f1-41af-91ab-2d7cd011db47"
Select-AzureRmSubscription -SubscriptionID 9ee2ec52-83c0-405e-a009-6636ead37acd

$resourceGroupName = "radhikgu-k8s4"
$resourceGroupDeploymentName = "$($resourceGroupName)Deployment"

# Create a resource group:
New-AzureRmResourceGroup -Name $resourceGroupName -Location "West Central US"

# Deploy template to resource group: Deploy using a local template and parameter file
New-AzureRmResourceGroupDeployment  -Name $resourceGroupDeploymentName `
                                    -ResourceGroupName $resourceGroupName `
                                    -TemplateFile "E:\Documents\GitHub\AzureStack-QuickStart-Templates\101-acsengine-kubernetes\azure_azuredeploy.json" `
                                    -TemplateParameterFile "E:\Documents\GitHub\AzureStack-QuickStart-Templates\101-acsengine-kubernetes\azure_azuredeploy.parameters.json"


# Deploy in one-node Azure Stack #######################################################################################################
Import-Module C:\CloudDeployment\AzureStack.Connect.psm1

Add-AzureRmEnvironment -Name "AzureStackUser" -ArmEndpoint "https://management.local.azurestack.external"
$TenantID = Get-AzsDirectoryTenantId -AADTenantName "azurestackci14.onmicrosoft.com" -EnvironmentName AzureStackUser
$TenantID
$UserName='tenantadmin1@msazurestack.onmicrosoft.com'
$Password='User@123'| ConvertTo-SecureString -Force -AsPlainText
$Credential= New-Object PSCredential($UserName,$Password)
Login-AzureRmAccount -EnvironmentName "AzureStackUser" -TenantId $TenantID -Credential $Credential 
Select-AzureRmSubscription -SubscriptionId dcfb1915-2c88-4c95-877d-24c4b402999b

$resourceGroupName = "radhikgu-k8s7d"
$resourceGroupDeploymentName = "$($resourceGroupName)Deployment"

# Create a resource group:
New-AzureRmResourceGroup -Name $resourceGroupName -Location "local"

# Deploy template to resource group: Deploy using a local template and parameter file
New-AzureRmResourceGroupDeployment  -Name $resourceGroupDeploymentName -ResourceGroupName $resourceGroupName `
                                    -TemplateFile "C:\Kubernetes\azuredeploy.json" `
                                    -TemplateParameterFile "C:\Kubernetes\azuredeploy.parameters.json" -Verbose

# Deploy in multi-node Azure Stack #######################################################################################################

Import-Module C:\CloudDeployment\AzureStack.Connect.psm1

Add-AzureRmEnvironment -Name "AzureStackUser" -ArmEndpoint "https://management.redmond.ext-u15e0303.masd.stbtest.microsoft.com"
$TenantID = Get-AzsDirectoryTenantId -AADTenantName "azurestackci14.onmicrosoft.com" -EnvironmentName AzureStackUser
$TenantID
$UserName='tenantadmin1@msazurestack.onmicrosoft.com'
$Password='User@123'| ConvertTo-SecureString -Force -AsPlainText
$Credential= New-Object PSCredential($UserName,$Password)
Login-AzureRmAccount -EnvironmentName "AzureStackUser" -TenantId $TenantID -Credential $Credential 
Select-AzureRmSubscription -SubscriptionId 24a373a3-5c06-49bc-b8e8-f48921ea8336

$resourceGroupName = "radhikgu-k8s4d"
$resourceGroupDeploymentName = "$($resourceGroupName)Deployment"

# Create a resource group:
New-AzureRmResourceGroup -Name $resourceGroupName -Location "redmond"

# Deploy template to resource group: Deploy using a local template and parameter file
New-AzureRmResourceGroupDeployment  -Name $resourceGroupDeploymentName -ResourceGroupName $resourceGroupName `
                                    -TemplateFile "C:\Kubernetes\azuredeploy_multi.json" `