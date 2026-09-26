Phase 5: Complete Deployment & Validation Script


🛠️ Step 1: Azure PowerShell & CLI Provisioning (Management Plane)

Execute these commands from Azure Cloud Shell or a local authenticated PowerShell session targeting subscription sub-ent-platform-prod (41a2b403-5b13-4a58-8cc0-c3ec75dba78a).

# ==============================================================================
# 1. Environment Context & Context Setting
# ==============================================================================
$SubscriptionId = "Sub-id"
Set-AzContext -SubscriptionId $SubscriptionId

# Define Resource Group & Principal Parameters
$HubRG = "rg-prd-hub-network-001"
$AppRG = "rg-prd-app-privatelink-001"
$AdminPrincipalId = "<admin-object-id>" # Replace with target Entra ID Admin Object ID

# ==============================================================================
# 2. Entra PIM Eligible Assignment (JIT Role Assignment)
# ==============================================================================
$SubScope = "/subscriptions/$SubscriptionId"
$RoleDef = Get-AzRoleDefinition -Name "Contributor"

# Request Just-In-Time Eligible Contributor Role Assignment
New-AzRoleEligibilityScheduleRequest `
  -Name (New-Guid) `
  -Scope $SubScope `
  -PrincipalId $AdminPrincipalId `
  -RoleDefinitionId $RoleDef.Id `
  -RequestType "AdminAssign"


Section B: Azure Route Server Verification (Phase 3 Control Plane)

Run via Azure PowerShell:

# Verify Learned BGP Routes from Linux NVA Peer
Get-AzRouteServerPeerLearnedRoute `
  -ResourceGroupName "rg-prd-hub-network-001" `
  -RouteServerName "route-server-hub-001" `
  -PeerName "peer-linux-vm" | Format-Table



Section D: Identity & Governance Audit (Phase 5 Management Plane)

Run via Azure PowerShell:

# Audit Subscription Scope Active vs Eligible Role Assignments to ensure Zero Permanent Standing Access
Get-AzRoleAssignment -Scope "/subscriptions/sub-id" | 
  Select-Object DisplayName, RoleDefinitionName, Scope | Format-Table
