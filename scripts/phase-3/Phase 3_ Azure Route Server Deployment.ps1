
<#
.SYNOPSIS
 Phase 3: Azure Route Server Deployment
    Target Subscription: sub-ent-platform-prod (SUB_ID)
#>
### ROUTE SERVER PROCESS TAKES TIME 20+ MINUTES , PLEASE BE PATIENT. 

$SubscriptionId = "SUB_ID"
$Location       = "eastus"
$RGHub          = "rg-prd-hub-network-001"
$RouteServerName = "route-server-hub-001"
$PipName        = "pip-routeserver-001"

Set-AzContext -SubscriptionId $SubscriptionId

# 1. Create a Standard Public IP for the Route Server
Write-Host "Creating Public IP for Route Server..." -ForegroundColor Cyan
$pip = New-AzPublicIpAddress -ResourceGroupName $RGHub `
    -Name $PipName `
    -Location $Location `
    -AllocationMethod Static `
    -Sku Standard `
    -IpAddressVersion IPv4

# 2. Get the Hub VNet and RouteServerSubnet
$vnetHub = Get-AzVirtualNetwork -Name "vnet-hub-001" -ResourceGroupName $RGHub
$rsSubnet = Get-AzVirtualNetworkSubnetConfig -Name "RouteServerSubnet" -VirtualNetwork $vnetHub

# 3. Deploy Azure Route Server
Write-Host "Deploying Azure Route Server ($RouteServerName)..." -ForegroundColor Cyan
New-AzRouteServer -ResourceGroupName $RGHub `
    -RouteServerName $RouteServerName `
    -Location $Location `
    -PublicIp $pip `
    -HostedSubnet $rsSubnet.Id

Write-Host "Phase 3 Azure Route Server Deployment Completed Successfully!" -ForegroundColor Green


