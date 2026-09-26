## 📜 Automation Script (Azure PowerShell via CloudShell)

```powershell
# scripts/phase-1/01-governance-setup.ps1
# Executed via Azure CloudShell (PS /home/ananda>)

# Project 4 - Phase 1 & 2: Governance & Network Topology Deployment
# Target Subscription: sub-ent-platform-prod (41a2b403-5b13-4a58-8cc0-c3ec75dba78a)

$SubscriptionId = "41a2b403-5b13-4a58-8cc0-c3ec75dba78a"
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

# Set Active Subscription Context
Set-AzContext -SubscriptionId $SubscriptionId

# Provision Core Resource Groups with Tags
New-AzResourceGroup -Name $RGHub -Location $Location -Tag $Tags -Force
New-AzResourceGroup -Name $RGApp -Location $Location -Tag $Tags -Force
```

---