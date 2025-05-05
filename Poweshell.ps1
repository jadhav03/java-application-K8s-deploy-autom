# Set vault context
$vault = Get-AzRecoveryServicesVault -Name "<vault-name>" -ResourceGroupName "<resource-group>"
Set-AzRecoveryServicesVaultContext -Vault $vault

# Get containers (you can specify type if needed, e.g., AzureVM, AzureSQL)
$containers = Get-AzRecoveryServicesBackupContainer -ContainerType AzureVM

foreach ($container in $containers) {
    # Get items inside the container
    $items = Get-AzRecoveryServicesBackupItem -Container $container

    foreach ($item in $items) {
        if ($item.DeleteState -eq "ToBeDeleted") {
            # Forcefully remove the item
            Remove-AzRecoveryServicesBackupItem -Item $item -Force
        }
    }
}



Remove-AzRecoveryServicesVault -VaultId $myVault -Force
