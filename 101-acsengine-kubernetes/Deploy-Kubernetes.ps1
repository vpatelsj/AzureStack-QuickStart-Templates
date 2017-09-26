# Login to your Azure account / subscription – this will prompt you with an interactive login.

#Add-AzureRmAccount -EnvironmentName AzurePublicCloud -TenantId 9ee2ec52-83c0-405e-a009-6636ead37acd
Add-AzureRmAccount
#
#Add-AzureRmAccount -Credential $cred -SubscriptionId 9ee2ec52-83c0-405e-a009-6636ead37acd -TenantId 72f988bf-86f1-41af-91ab-2d7cd011db47

Get-AzureRmADApplication -ApplicationId 7c4b28f9-526f-4ce6-9b2a-ba173dec1722

Select-AzureRmSubscription -SubscriptionID 9ee2ec52-83c0-405e-a009-6636ead37acd

$resourceGroupName = "radhikgu-k84"
$resourceGroupDeploymentName = "$($resourceGroupName)Deployment"

# Create a resource group:
New-AzureRmResourceGroup -Name $resourceGroupName -Location "West Central US"

# Deploy template to resource group: Deploy using a local template and parameter file
New-AzureRmResourceGroupDeployment  -Name $resourceGroupDeploymentName `
                                    -ResourceGroupName $resourceGroupName `
                                    -TemplateFile "E:\Documents\GitHub\AzureStack-QuickStart-Templates\101-acsengine-kubernetes\azure_azuredeploy.json" `
                                    -TemplateParameterFile "E:\Documents\GitHub\AzureStack-QuickStart-Templates\101-acsengine-kubernetes\azure_azuredeploy.parameters.json"




