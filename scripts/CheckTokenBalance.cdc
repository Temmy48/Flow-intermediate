import FungibleToken from 0x05
import EchoCoin from 0x05

pub fun main(account: Address) {

    // Attempt to borrow PublicVault capability
    let publicVault: &EchoCoin.Vault{FungibleToken.Balance, 
    FungibleToken.Receiver, EchoCoin.VaultInterface}? =
        getAccount(account).getCapability(/public/Vault)
            .borrow<&EchoCoin.Vault{FungibleToken.Balance, 
            FungibleToken.Receiver, EchoCoin.VaultInterface}>()

    if (publicVault == nil) {
        // Create and link an empty vault if capability is not present
        let newVault <- EchoCoin.createEmptyVault()
        getAuthAccount(account).save(<-newVault, to: /storage/VaultStorage)
        getAuthAccount(account).link<&EchoCoin.Vault{FungibleToken.Balance, 
        FungibleToken.Receiver, EchoCoin.VaultInterface}>(
            /public/Vault,
            target: /storage/VaultStorage
        )
        log("Empty vault created and linked")
        
        // Borrow the vault capability again to display its balance
        let retrievedVault: &EchoCoin.Vault{FungibleToken.Balance}? =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&EchoCoin.Vault{FungibleToken.Balance}>()
        log("Balance of the new vault: ")
        log(retrievedVault?.balance)
    } else {
        log("Vault already exists and is properly linked")
        
        // Borrow the vault capability for further checks
        let checkVault: &EchoCoin.Vault{FungibleToken.Balance, 
        FungibleToken.Receiver, EchoCoin.VaultInterface} =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&EchoCoin.Vault{FungibleToken.Balance, 
                FungibleToken.Receiver, EchoCoin.VaultInterface}>()
                ?? panic("Vault capability not found")
        
        // Check if the vault's UUID is in the list of vaults
        if EchoCoin.vaults.contains(checkVault.uuid) {     
            log("Balance of the existing vault:")       
            log(publicVault?.balance)
            log("This is a EchoCoin vault")
        } else {
            log("This is not a EchoCoin vault")
        }
    }
}
