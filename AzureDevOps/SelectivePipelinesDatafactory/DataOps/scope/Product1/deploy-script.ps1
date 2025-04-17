param
(
    [parameter(Mandatory = $true)] [String] $rootFolder,
    [parameter(Mandatory = $true)] [String] $dataFactoryName,
    [parameter(Mandatory = $true)] [String] $resourceGroupName,
    [parameter(Mandatory = $true)] [String] $location,
    [parameter(Mandatory = $true)] [String] $configPath
)
$adf = Import-AdfFromFolder -RootFolder "$rootFolder" -FactoryName $dataFactoryName
$opt = New-AdfPublishOption

##################### THIS IS THE PART THAT REQUIRES CUSTOMIZATION ####################################
# Team1 artifacts to be deployed by this script
# Pipelines and datasets from Team_1 folder in ADF:
$selectedObjects = $adf.GetObjectsByFolderName('team1')
# Linked services:
$opt.Includes.Add("linkedService.AzureDataLakeStorage1", "")
# Integration runtime:
$opt.Includes.Add("integrationruntime.*", "")
# Data Factory object (includes global params):
$opt.Includes.Add("factory.*", "")
################################ END OF CUSTOMIZED PART ###############################################

$opt.Includes += $selectedObjects
# Don't provision new instance of ADF if it doesn't exist
$opt.CreateNewInstance = $false
$opt.TriggerStopMethod = "DeployableOnly"
Publish-AdfV2FromJson -RootFolder "$rootFolder" -ResourceGroupName "$resourceGroupName" -DataFactoryName "$dataFactoryName" -Location "$location" -Option $opt -Stage "$configPath"