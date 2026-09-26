$providers = @("Microsoft.Resources", "Microsoft.Network", "Microsoft.Management", "Microsoft.Security")
foreach ($p in $providers) {
    Get-AzResourceProvider -ProviderNamespace $p | Select-Object ProviderNamespace, RegistrationState
}
