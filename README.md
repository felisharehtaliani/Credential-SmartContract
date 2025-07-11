# Soulbound Credential Smart Contract (Sepolia Deployment)
Credential fraud and inefficient verification processes continue to challenge cross-border education and professional mobility. This repository presents a Solidity-based smart contract system to address the lack of verifiable, issuer-independent digital credentials in decentralized environments.

## 🔑 Key Features

- Issue credentials that are permanently bound to the recipient's wallet (non-transferable)
- Assign metadata, expiration date, and cryptographic integrity (metaHash) to each token
- Support credential revocation by authorized validator or self-revocation by the owner
- Enable third-party public verification without requiring backend systems

## 📁 Project Structure

```text
credential-sbt-verifier/
├── contracts/
│   ├── CredentialSBT.sol      # Main contract for issuing and revoking credentials
│   └── Verifier.sol           # Read-only contract for verifying credential status
│
├── deployments/
│   └── sepolia.txt            # Deployment address and transaction record
│
├── LICENSE                    # MIT License declaration
└── README.md                  # Project documentation
```

## 🚀 Deployment & Testing

- Developed using [Remix IDE](https://remix.ethereum.org)
- Deployed and tested via **Injected Web3 (MetaMask)** environment
- Solidity version: `^0.8.20`
- Test Network: **Ethereum Sepolia Testnet**

### Deployment Details

- **CredentialSBT Contract Address**: [`0xfdC6A964EBD738f2279388eC12B00AD53c48cD3b`](https://sepolia.etherscan.io/address/0xfdC6A964EBD738f2279388eC12B00AD53c48cD3b)
- **Transaction Hash**: [`0x36cbee...6365a`](https://sepolia.etherscan.io/tx/0x36cbee4e023dfc83ee53b791c564e331f00b19890310fb5a843882bf3716365a)
- **Network**: Ethereum Sepolia Testnet

This on-chain deployment serves as part of the experimental validation discussed in the associated publication. Deployment logs can be referenced in the publication appendix or provided upon request for replication and audit purposes.


## ⚙️ Smart Contract Functions

### Issuer Functions
- `attestAndMint(...)`  
  Issue a new Soulbound credential with metadata and optional expiration.

### Validator Functions
- `revoke(tokenId)`  
  Revoke a credential by token ID.

### Token Holder Functions
- `burn()`  
  Self-revoke the credential from the holder’s wallet.

### Verifier Contract Functions
- `verify(tokenId)` → Returns whether the credential is valid
- `getOwner(tokenId)` → Returns the owner address
- `getStatus(tokenId)` → Returns status: Valid / Revoked / Expired
- `getMetadataURI(tokenId)` → Returns URI string of the credential metadata

## 🔗 How to Interact

You can interact with the deployed contracts using:
- [Remix IDE](https://remix.ethereum.org)
- Sepolia Etherscan's "Read/Write Contract" tab:
  [`CredentialSBT`](https://sepolia.etherscan.io/address/0xfdC6A964EBD738f2279388eC12B00AD53c48cD3b#writeContract)

For testing purposes, use a Sepolia testnet wallet with assigned roles:
- Issuer: Authorized to mint credentials
- Validator: Authorized to revoke credentials
- Wallet holder: Receives and owns the Soulbound Token

These roles reflect a role-based architecture design, ensuring separation of credential lifecycle authority.

## 📜 License

This project is released under the [MIT License](./LICENSE). You are free to use, modify, and distribute the source code with proper attribution. No warranty is provided.


## 👤 Author

**Deylna Manayra Felisha Rehtaliani**  
Telkom University – Blockchain Research  
For inquiries or collaboration, please contact via GitHub or academic channels.
