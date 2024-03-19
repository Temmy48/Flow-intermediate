import FungibleToken from 0x05
import EchoCoin from 0x05

transaction(receiver: Address, amount: UFix64) {

    prepare(signer: AuthAccount) {
        // Borrow the EchoCoin Minter reference
        let minter = signer.borrow<&EchoCoin.Minter>(from: /storage/MinterStorage)
            ?? panic("You are not the EchoCoin minter")
        
        // Borrow the receiver's EchoCoin Vault capability
        let receiverVault = getAccount(receiver)
            .getCapability<&EchoCoin.Vault{FungibleToken.Receiver}>(/public/Vault)
            .borrow()
            ?? panic("Error: Check your EchoCoin Vault status")
        
        // Minted tokens reference
        let mintedTokens <- minter.mintToken(amount: amount)

        // Deposit minted tokens into the receiver's EchoCoin Vault
        receiverVault.deposit(from: <-mintedTokens)
    }

    execute {
        log("EchoCoin minted and deposited successfully")
        log("Tokens minted and deposited: ".concat(amount.toString()))
    }
}