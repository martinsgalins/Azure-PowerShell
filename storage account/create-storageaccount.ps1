#Set location of VHD file
$LocalPath = 'd:\temp\disk01.vhd'
#Set ResourceGroup Name
$RGname ='test-vhdupload'
#Set Azure subscription ID
$Subscription = 'xxx'
#Set Location
$Location = 'West Europe'
#Connect to Azure with user account which has perrmissions to create resource groups and resources
Connect-AzAccount
Set-AzContext -Subscription $Subscription
$SAName = -join ('vhdupload',(get-date -format yyyyMMdd))
New-AzResourceGroup -Name $RGname -Location $Location# -Tag @{'RG'='APP'}
$SA = New-AzStorageAccount -ResourceGroupName $RGname -AccountName $SAName -Location $Location -SkuName Standard_LRS
$ctx = $SA.Context
$container = New-AzStorageContainer -Name "vhd" -Context $ctx -Permission blob
# upload a file to the Hot access tier
Write-Host 'Uploading VHD to Azure!'
Set-AzStorageBlobContent -File $LocalPath -Container $container.name -Blob "disk01.vhd" -Context $ctx -StandardBlobTier Hot
Write-Host 'Upload Completed!'