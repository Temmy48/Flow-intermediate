// Import FungibleToken and EchoCoin contracts from version 0x05
import FungibleToken from 0x05
import EchoCoin from 0x05

// Create EchoCoin Vault Transaction
transaction () {

    // Define references
    let userVault: &EchoCoin.Vault{FungibleToken.Balance, 
        FungibleToken.Provider, 
        FungibleToken.Receiver, 
        EchoCoin.VaultInterface}?
    let account: AuthAccount

    prepare(acct: AuthAccount) {

        // Borrow the vault capability and set the account reference
        self.userVault = acct.getCapability(/public/Vault)
            .borrow<&EchoCoin.Vault{FungibleToken.Balance, FungibleToken.Provider, FungibleToken.Receiver, EchoCoin.VaultInterface}>()
        self.account = acct
    }

    execute {
        if self.userVault == nil {
            // Create and link an empty vault if none exists
            let emptyVault <- EchoCoin.createEmptyVault()
            self.account.save(<-emptyVault, to: /storage/VaultStorage)
            self.account.link<&EchoCoin.Vault{FungibleToken.Balance, 
                FungibleToken.Provider, 
                FungibleToken.Receiver, 
                EchoCoin.VaultInterface}>(/public/Vault, target: /storage/VaultStorage)
            log("Empty vault created and linked")
        } else {
            log("Vault already exists and is properly linked")
        }
    }
}