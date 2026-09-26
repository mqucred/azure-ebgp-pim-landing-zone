# Set context to target subscription
Select-AzSubscription -SubscriptionId "41a2b403-5b13-4a58-8cc0-c3ec75dba78a"

# List of Resource Groups created for Project 4
$resourceGroups = @(
    "rg-prd-app-privatelink-001",
    "rg-prd-hub-network-001"
)

# Remove core project resource groups in parallel
foreach ($rg in $resourceGroups) {
    Write-Host "Deleting Resource Group: $rg..." -ForegroundColor Yellow
    Remove-AzResourceGroup -Name $rg -Force -AsJob
}

# Optional: Remove NetworkWatcherRG if no other resources require monitoring
# Remove-AzResourceGroup -Name "NetworkWatcherRG" -Force -AsJob

Write-Host "Teardown jobs submitted successfully. Azure is processing deletions in the background." -ForegroundColor Green