## 📜 Automation Script (Azure PowerShell via CloudShell)

```powershell
# scriptsphase-202-network-topology.ps1
# Executed via Azure CloudShell (PS homeananda)

# Project 4 - Phase 2 Hub-and-Spoke VNet & Subnet Topology Deployment
# Target Subscription sub-ent-platform-prod (41a2b403-5b13-4a58-8cc0-c3ec75dba78a)

$SubscriptionId = 41a2b403-5b13-4a58-8cc0-c3ec75dba78a
$Location       = eastus
$RGHub          = rg-prd-hub-network-001
$RGApp          = rg-prd-app-privatelink-001

$Tags = @{
    Environment   = Production
    Project       = Project-4-ZeroTrust-LZ
    Owner         = Cloud-SecOps-Team
    CostCenter    = CC-INFRA-702
    SecurityLevel = High-Restricted
}

Set-AzContext -SubscriptionId $SubscriptionId

# 1. Build Hub Network & Subnets
Write-Host Deploying vnet-hub-001... -ForegroundColor Cyan
$subnetHub = New-AzVirtualNetworkSubnetConfig -Name HubSubnet -AddressPrefix 10.0.1.024
$subnetBGP = New-AzVirtualNetworkSubnetConfig -Name RouteServerSubnet -AddressPrefix 10.0.2.024
$subnetFW  = New-AzVirtualNetworkSubnetConfig -Name AzureFirewallSubnet -AddressPrefix 10.0.3.024

$vnetHub = New-AzVirtualNetwork -ResourceGroupName $RGHub `
    -Location $Location `
    -Name vnet-hub-001 `
    -AddressPrefix 10.0.0.016 `
    -Subnet $subnetHub, $subnetBGP, $subnetFW `
    -Tag $Tags

# 2. Build Spoke Network & Subnets
Write-Host Deploying vnet-spoke-001... -ForegroundColor Cyan
$subnetApp = New-AzVirtualNetworkSubnetConfig -Name WorkloadSubnet -AddressPrefix 10.1.1.024
$subnetPE  = New-AzVirtualNetworkSubnetConfig -Name PrivateEndpointSubnet -AddressPrefix 10.1.2.024

$vnetSpoke = New-AzVirtualNetwork -ResourceGroupName$RGApp `
    -Location $Location `
    -Name vnet-spoke-001 `
    -AddressPrefix 10.1.0.016 `
    -Subnet $subnetApp,$subnetPE `
    -Tag $Tags

# 3. Establish Bidirectional VNet Peering
Add-AzVirtualNetworkPeering -Name peer-hub-to-spoke `
    -VirtualNetwork $vnetHub `
    -RemoteVirtualNetworkId $vnetSpoke.Id `
    -AllowForwardedTraffic -AllowGatewayTransit

Add-AzVirtualNetworkPeering -Name peer-spoke-to-hub `
    -VirtualNetwork $vnetSpoke `
    -RemoteVirtualNetworkId $vnetHub.Id `
    -AllowForwardedTraffic
```

---