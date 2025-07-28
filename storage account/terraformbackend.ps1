Connect-AzAccount -DeviceCode
# Define variables
$subscriptionId = "xxxxx"
$resourceGroupName = "test-terraformbackend"
$location = "swedencentral"
$storageAccountName = "xxxxx" # must be globally unique and lowercase
$containerName = "tfstate"
$statefile = "statefile.tfstate"

# Set the context to the correct subscription
Set-AzContext -SubscriptionId $subscriptionId

# Create the resource group (if it doesn't exist)
if (-not (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue)) {
    Write-Host "Creating resource group '$resourceGroupName'..."
    New-AzResourceGroup -Name $resourceGroupName -Location $location
}

# Create the storage account
Write-Host "Creating storage account '$storageAccountName'..."
$storageAccount = New-AzStorageAccount -ResourceGroupName $resourceGroupName `
    -Name $storageAccountName `
    -Location $location `
    -SkuName Standard_LRS `
    -Kind StorageV2

# Get the storage account context
$ctx = $storageAccount.Context

# Create the blob container
Write-Host "Creating blob container '$containerName'..."
New-AzStorageContainer -Name $containerName -Context $ctx

# Retrieve the storage account key
$keys = Get-AzStorageAccountKey -ResourceGroupName $resourceGroupName -Name $storageAccountName
$accessKey = $keys[0].Value

# Output in the requested format
Write-Host "`n# === Terraform-style Output ==="
Write-Host "access_key           = `"$accessKey`""
Write-Host "storage_account_name = `"$storageAccountName`""
Write-Host "container_name       = `"$containerName`""
Write-Host "container_name       = `"$statefile`""
