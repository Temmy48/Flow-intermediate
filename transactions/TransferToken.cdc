import FungibleToken from 0x05
import EchoCoin from 0x05

transaction(receiverAccount: Address, amount: UFix64) {

    // Define references for the sender's and receiver's vaults
    let signerVault: &EchoCoin.Vault
    let receiverVault: &EchoCoin.Vault{FungibleToken.Receiver}

    prepare(acct: AuthAccount) {
        // Borrow references and handle errors
        self.signerVault = acct.borrow<&EchoCoin.Vault>(from: /storage/VaultStorage)
            ?? panic("Vault belonging to the sender could not be located")

        self.receiverVault = getAccount(receiverAccount)
            .getCapability(/public/Vault)
            .borrow<&EchoCoin.Vault{FungibleToken.Receiver}>()
            ?? panic("Vault belonging to the receiver could not be found")
    }

    execute {
        // Withdraw tokens from the sender's vault and deposit them into the receiver's vault
        self.receiverVault.deposit(from: <-self.signerVault.withdraw(amount: amount))
        log("Tokens have been effectively moved from the sender to the recipient.")
    }
}