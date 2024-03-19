// Import FungibleToken and FlowToken contracts from version 0x05
import FungibleToken from 0x05
import FlowToken from 0x05

transaction {

    // Define references
    let flowTokenVault: &FlowToken.Vault?
    let account: AuthAccount

    prepare(acct: AuthAccount) {
        // Borrow the FlowToken vault reference if it exists
        self.flowTokenVault = acct.getCapability(/public/FlowVault)
            .borrow<&FlowToken.Vault>()

        self.account = acct
    }

    execute {
    if self.flowTokenVault == nil {
        // Generate and associate the FlowToken vault if it doesn't currently exist
        let newVault <- FlowToken.createEmptyVault()
        self.account.save(<-newVault, to: /storage/FlowVault)
        self.account.link<&FlowToken.Vault{FungibleToken.Balance, 
            FungibleToken.Receiver, 
            FungibleToken.Provider}>(/public/FlowVault, target: /storage/FlowVault)
        log("An empty FlowToken vault has been created and linked")
    } else {
        log("The FlowToken vault already exists and is correctly linked")
    }
}
}