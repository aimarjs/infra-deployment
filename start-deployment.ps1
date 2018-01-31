$subscription = "aimar-sandbox-ava"
$environment = "cosmospoc-beta4"
$Location = "West Europe"

# log in to azure
Add-AzureRmAccount

# set login context to right subscription (if necessary)
Set-AzureRmContext -SubscriptionName $subscription

# create resource group
New-AzureRmResourceGroup -Name $environment -Location $Location

# test arm template ( no news => is good news! )
Test-AzureRmResourceGroupDeployment -ResourceGroupName $environment -TemplateFile "azuredeploy.json" -TemplateParameterFile "azuredeploy.parameters.json"

# deployment
New-AzureRmResourceGroupDeployment -Name "cosmospoc-deploy131" -ResourceGroupName $environment -TemplateFile "azuredeploy.json" -TemplateParameterFile "azuredeploy.parameters.json"
