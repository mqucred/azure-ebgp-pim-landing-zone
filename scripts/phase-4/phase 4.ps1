Azure CLI / PowerShell & Bash Deployment Commands1. Infrastructure Deployment Scripts (Azure PowerShell / CLI)To deploy the Phase 4 cross-boundary Private Link Service and Private Endpoint infrastructure, the following Azure PowerShell and CLI commands were executed:Deploy Internal Load Balancer & Subnets:PowerShell# Create resource group
New-AzResourceGroup -Name "rg-prd-app-privatelink-001" -Location "EastUS"

# Provision Subnets in vnet-spoke-001
$vnet = Get-AzVirtualNetwork -Name "vnet-spoke-001" -ResourceGroupName "rg-prd-app-privatelink-001"

# Create Internal Load Balancer slb-app-001
$frontendIP = New-AzLoadBalancerFrontendIpConfig -Name "FrontendIpConfig" `
  -PrivateIpAddress "10.1.1.4" `
  -SubnetId $vnet.Subnets[0].Id

$backendPool = New-AzLoadBalancerBackendAddressPoolConfig -Name "BackendPool01"

New-AzLoadBalancer -ResourceGroupName "rg-prd-app-privatelink-001" `
  -Name "slb-app-001" `
  -Location "EastUS" `
  -Sku Standard `
  -FrontendIpConfiguration $frontendIP `
  -BackendAddressPool $backendPool
Create Private Link Service:PowerShell# Retrieve ILB Frontend IP Configuration
$slb = Get-AzLoadBalancer -Name "slb-app-001" -ResourceGroupName "rg-prd-app-privatelink-001"
$feConfig = Get-AzLoadBalancerFrontendIpConfig -LoadBalancer$slb -Name "FrontendIpConfig"

# Retrieve NAT Subnet (WorkloadSubnet)
$natSubnet = Get-AzVirtualNetworkSubnetConfig -Name "WorkloadSubnet" -VirtualNetwork $vnet

# Create Private Link Service with Auto-Approval Disabled
New-AzPrivateLinkService -Name "pls-cross-boundary-001" `
  -ResourceGroupName "rg-prd-app-privatelink-001" `
  -Location "EastUS" `
  -LoadBalancerFrontendIpConfiguration $feConfig `
  -IpConfiguration @{
      Name = "pls-nat-config";
      Subnet = $natSubnet;
      Primary = $true;
      PrivateIpAddressAllocation = "Dynamic"
  } `
  -Visibility "Restricted" `
  -AutoApproval @()
Create Private Endpoint & Request Connection:PowerShell# Retrieve Private Link Service Alias
$pls = Get-AzPrivateLinkService -Name "pls-cross-boundary-001" -ResourceGroupName "rg-prd-app-privatelink-001"
$peSubnet = Get-AzVirtualNetworkSubnetConfig -Name "PrivateEndpointSubnet" -VirtualNetwork $vnet

# Provision Private Endpoint pe-app-001
New-AzPrivateEndpoint -Name "pe-app-001" `
  -ResourceGroupName "rg-prd-app-privatelink-001" `
  -Location "EastUS" `
  -Subnet $peSubnet `
  -PrivateLinkServiceConnection @{
      Name = "pe-pls-conn-001";
      PrivateLinkServiceId = $pls.Id;
      RequestMessage = "Awaiting Approval"
  }
2. Verification & Status Check CommandsApprove Pending Private Endpoint Connection (Azure CLI / PowerShell):PowerShell# List Pending Connections
Get-AzPrivateLinkService -Name "pls-cross-boundary-001" -ResourceGroupName "rg-prd-app-privatelink-001" | Select-Object -ExpandProperty PrivateEndpointConnections

# Approve Connection
Approve-AzPrivateEndpointConnection `
  -ResourceGroupName "rg-prd-app-privatelink-001" `
  -ServiceName "pls-cross-boundary-001" `
  -Name "pe-app-001.9ff51bac-e43f-4..." `
  -Description "Approved after verification"

