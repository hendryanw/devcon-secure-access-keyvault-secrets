Param (
	[string] [Parameter(Mandatory=$true)] $ResourceGroupName,
	[string] [Parameter(Mandatory=$true)] $ResourceGroupLocation
)

$ErrorActionPreference = "Stop";

# Create a new Resource Group.
New-AzureRmResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation -Force

# Deploy the ARM template into the Resource Group.
New-AzureRmResourceGroupDeployment `
	-Name devcon-VM-deployment `
	-ResourceGroupName $ResourceGroupName `
	-TemplateFile (Join-Path $PSScriptRoot "azuredeploy.json") `
	-TemplateParameterFile (Join-Path $PSScriptRoot "azuredeploy.parameters.json")