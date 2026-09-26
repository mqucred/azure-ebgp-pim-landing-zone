<#
.SYNOPSIS
 Phase 2: Hub-and-Spoke VNet & Subnet Topology Deployment (Corrected)
#>

$SubscriptionId = "SUB_ID"
$Location       = "eastus"
$RGHub          = "rg-prd-hub-network-001"
$RGApp          = "rg-prd-app-privatelink-001"

$Tags = @{
    Environment   = "Production"
    Project       = "Project-4-ZeroTrust-LZ"
    Owner         = "Cloud-SecOps-Team"
    CostCenter    = "CC-INFRA-702"
    SecurityLevel = "High-Restricted"
}

Set-AzContext -SubscriptionId $SubscriptionId

# 1. Build Hub Network & Subnets
Write-Host "Deploying vnet-hub-001..." -ForegroundColor Cyan
$subnetHub = New-AzVirtualNetworkSubnetConfig -Name "HubSubnet" -AddressPrefix "10.0.1.0/24"
$subnetBGP = New-AzVirtualNetworkSubnetConfig -Name "RouteServerSubnet" -AddressPrefix "10.0.2.0/24"
$subnetFW  = New-AzVirtualNetworkSubnetConfig -Name "AzureFirewallSubnet" -AddressPrefix "10.0.3.0/24"

$vnetHub = New-AzVirtualNetwork -ResourceGroupName $RGHub `
    -Location $Location `
    -Name "vnet-hub-001" `
    -AddressPrefix "10.0.0.0/16" `
    -Subnet $subnetHub, $subnetBGP, $subnetFW `
    -Tag $Tags

# 2. Build Spoke Network & Subnets
Write-Host "Deploying vnet-spoke-001..." -ForegroundColor Cyan
$subnetApp = New-AzVirtualNetworkSubnetConfig -Name "WorkloadSubnet" -AddressPrefix "10.1.1.0/24"
$subnetPE  = New-AzVirtualNetworkSubnetConfig -Name "PrivateEndpointSubnet" -AddressPrefix "10.1.2.0/24"

$vnetSpoke = New-AzVirtualNetwork -ResourceGroupName $RGApp `
    -Location $Location `
    -Name "vnet-spoke-001" `
    -AddressPrefix "10.1.0.0/16" `
    -Subnet $subnetApp, $subnetPE `
    -Tag $Tags

# create Hub-to-Spoke peering (Allow gateway transit for Route Server)
Add-AzVirtualNetworkPeering -Name "peer-hub-to-spoke" `
    -VirtualNetwork $vnetHub `
    -RemoteVirtualNetworkId $vnetSpoke.Id `
    -AllowGatewayTransit -Force

# Create Spoke-to-Hub peering (Without the remote gateway flag)
Add-AzVirtualNetworkPeering -Name "peer-spoke-to-hub" `
    -VirtualNetwork $vnetSpoke `
    -RemoteVirtualNetworkId $vnetHub.Id -Force

Write-Host "Phase 2 Peering Fixed and Completed Successfully!" -ForegroundColor Green
