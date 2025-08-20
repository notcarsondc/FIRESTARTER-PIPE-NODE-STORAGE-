# Firestarter Storage Pipe node

## Introduction OF Node

Pipe Firestarter Storage Node
Overview

A Pipe Firestarter Storage Node is a decentralized engine for storing and delivering data across the Firestarter network. Unlike centralized cloud services (Google Drive, Cloudflare, AWS), these nodes are operated by independent participants. Each node adds capacity, speed, and redundancy to the system, making Firestarter faster, safer, and resistant to censorship.

# Key Characteristics

## Distributed Data Layer

- Splits files into encrypted chunks stored across many nodes.

- Eliminates single points of failure or control.

## High-Speed Content Delivery

- Functions like a decentralized CDN, reducing latency for users globally.

- Supports real-time file access, streaming, and app integrations.

## Blockchain Integration

- Anchored to Solana for accountability, settlement, and coordination.

- Currently powers over 1 PB of historical Solana blockchain data, cutting validator sync times by ~30%.

## Economic Incentives

- Users pay with $PIPE tokens (1 PIPE ≈ 1 GB).

- Tokens are burned for storage and re-minted as rewards to node operators.

- Creates a closed-loop, community-owned infrastructure.



---

## Installation 

### Step 1: Clone the repository
```bash
git clone https://github.com/notcarsondc/FIRESTARTER-PIPE-NODE-STORAGE- && cd FIRESTARTER-PIPE-NODE-STORAGE-

```

### Step 2: Run the script
```bash
chmod +x ./Pipe_Firestarter.sh
./Pipe_Firestarter.sh
```

- If this is your first time running it, the script will install required dependencies so click Y.
- During installation, some files will open; copy the text from them and save for later use.
- Make sure to copy your **Solana public key**, as you will need it for the faucet.

### Step 3: Get Solana Devnet faucet
- Visit [Solana Faucet](https://faucet.solana.com/) to receive Solana tokens on Devnet.
- You need at least **1 SOL** to swap for PIPE tokens.

### Step 4: Run the script again
```bash
./Pipe_Firestarter.sh
```
- The main interface will appear. Follow the options in order.

---

## Main Interface Options (Alpha)

1. **Swap SOL for PIPE**
   - You must have at least 1 SOL to swap for PIPE tokens.
   - You need PIPE tokens to upload files.

2. **Upload File**
   - Provide the **full path** of the file and a **file name** to save it.
   - Only after swapping SOL for PIPE can you upload files.


## Upload File Format

Here’s an example of how your upload file should look:

![Upload File Format](https://github.com/user-attachments/assets/63c8a411-55d1-4dc5-84ac-7401f7a2fc35)


3. **Check PIPE Token Usage**
   - See your PIPE token usage

4. **Check Credentials**
   - View your saved credentials if needed.

5. **Exit Script**
   - Exit the interface safely.

---

## Notes
- first swap SOL to get PIPE, then upload files.
- Uploading more files increases your PIPE token rewards.
- Always keep a copy of your credentials and Solana public key for future use.
- This is an alpha so don't miss 
