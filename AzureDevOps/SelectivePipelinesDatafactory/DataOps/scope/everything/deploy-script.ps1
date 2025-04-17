param
(
    [parameter(Mandatory = $true)] [String] $rootFolder,
    [parameter(Mandatory = $true)] [String] $dataFactoryName,
    [parameter(Mandatory = $true)] [String] $resourceGroupName,
    [parameter(Mandatory = $true)] [String] $location,
    [parameter(Mandatory = $true)] [String] $configPath
)
$opt = New-AdfPublishOption

# Don't provision new instance of ADF if it doesn't exist
$opt.CreateNewInstance = $false
# Delete objects that are not in the source code
$opt.DeleteNotInSource = $true
Publish-AdfV2FromJson -RootFolder "$rootFolder" -ResourceGroupName "$resourceGroupName" -DataFactoryName "$dataFactoryName" -Location "$location" -Option $opt -Stage "$configPath"