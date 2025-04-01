# Mintable Frame Contract

This project contains a simple ERC721 NFT contract designed for Farcaster frames that sends payments directly to the creator.

## Features

- ERC721 standard compliant
- Fixed price minting (0.0025 ETH)
- Direct payments to creator (no need for separate withdrawals)
- Custom token URI support

## Prerequisites

- [Git](https://git-scm.com/)
- [Foundry](https://getfoundry.sh/)
- An Ethereum wallet with a private key
- Access to an Ethereum RPC URL (Mainnet, Testnet, or local node)

## Installation

### 1. Install Foundry

If you don't have Foundry installed, run the following command:

```shell
curl -L https://foundry.paradigm.xyz | bash
```

Then run:

```shell
foundryup
```

This will install `forge`, `cast`, `anvil`, and `chisel`.

### 2. Clone the repository

```shell
git clone https://github.com/jc4p/mintable-frame-contract.git
cd mintable-frame-contract
```

### 3. Install dependencies

```shell
forge install
```

### 4. Build the project

```shell
forge build
```

## Configuration

### Setting up environment variables

Create a `.env` file in the root directory with the following variables:

```
RPC_URL=https://mainnet.base.org
PRIVATE_KEY=your_private_key_without_0x_prefix
```

Replace:
- The Base RPC URL is already provided as `https://mainnet.base.org`
- `your_private_key_without_0x_prefix` with your wallet's private key (without the 0x prefix)

**Important**: Never commit your `.env` file to version control. The `.gitignore` file should already be set up to ignore it.

### Setting up the BASE_URI

Before deployment, update the `BASE_URI` in both the contract and test file to point to your server:

1. Set up the server (available at [github.com/jc4p/mintable-frame-server](https://github.com/jc4p/mintable-frame-server))
2. Update the `BASE_URI` in `src/FarcasterNFT.sol` to be your server URL + `/tokens/`
3. Update the `BASE_URI` in `test/FarcasterNFT.t.sol` to match the same value

Example:
```solidity
// In src/FarcasterNFT.sol
string public constant BASE_URI = "https://your-server-url.com/tokens/";

// In test/FarcasterNFT.t.sol
string constant BASE_URI = "https://your-server-url.com/tokens/";
```

### Source the environment variables

```shell
source .env
```

### Validate your environment setup

You can verify that your environment variables are set up correctly by running the validation script:

```shell
forge script script/ValidateEnv.s.sol
```

This script will:
- Check that your private key is properly formatted
- Derive and display your wallet address
- Verify that your RPC URL is configured

If everything is set up correctly, you'll see a success message with your wallet address. If there are issues, the script will provide detailed error messages to help you fix them.

You can also check your wallet's balance on the Base network using:

```shell
cast balance YOUR_WALLET_ADDRESS --rpc-url $RPC_URL
```

Make sure you have enough ETH to cover the gas fees for deployment.

## Testing

Run the test suite:

```shell
forge test
```

For more verbose output, add the `-vv` flag:

```shell
forge test -vv
```

## Deployment

### 1. Dry run (simulation)

To simulate the deployment without actually broadcasting transactions:

```shell
forge script script/FarcasterNFT.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

### 2. Actual deployment

To deploy the contract:

```shell
forge script script/FarcasterNFT.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```

### 3. Retrieving the deployed contract address

After deployment, the contract address will be shown in the console output. You can find it in the "Deployed to" section.

Alternatively, you can see deployed contracts in the `broadcast` directory that's created after deployment. Look for the most recent JSON file and find the deployed contract address.

```shell
cat broadcast/FarcasterNFT.s.sol/*/run-latest.json | grep -A1 "\"contractAddress\""
```

### 4. Viewing your contract on Basescan

Once your contract is deployed, you can view it on Basescan by visiting:

```
https://basescan.org/address/YOUR_CONTRACT_ADDRESS
```

Replace `YOUR_CONTRACT_ADDRESS` with the actual contract address from the deployment output. 

For example:
```
https://basescan.org/address/0x1234567890123456789012345678901234567890
```

This will show you the contract's transactions, token transfers, and other onchain activity.

## Contract Verification

### Getting a Basescan API Key

1. Visit [basescan.org](https://basescan.org/)
2. Create an account or sign in
3. Navigate to your account profile by clicking on your address in the top-right corner
4. Select "API Keys" from the menu
5. Click "Add" to create a new API key
6. Enter a name for your API key (e.g., "FarcasterNFT")
7. Complete any verification steps required
8. Copy the generated API key
9. Add the API key to your `.env` file:
   ```
   BASESCAN_API_KEY=your_api_key_here
   ```
10. Source your `.env` file:
    ```shell
    source .env
    ```

### Verifying Your Contract

To verify your contract on Basescan (after deployment):

```shell
forge verify-contract --chain-id 8453 --watch --compiler-version 0.8.28 $CONTRACT_ADDRESS src/FarcasterNFT.sol:FarcasterNFT --etherscan-api-key $BASESCAN_API_KEY
```

The chain ID `8453` is for Base mainnet.

### Manual Contract Verification (Alternative Method)

If you have trouble with the automated verification, you can verify your contract manually on Basescan:

1. First, flatten your contract into a single file:

```shell
forge flatten src/FarcasterNFT.sol > FarcasterNFT_flattened.sol
```

2. Go to [Basescan](https://basescan.org/) and search for your contract address

3. Click on the "Contract" tab

4. Click on the "Verify & Publish" link

5. Fill in the verification form:
   - Contract Name: `FarcasterNFT`
   - Compiler Type: `Solidity (Single file)`
   - Compiler Version: `v0.8.28+commit.7893614a`
   - Open Source License Type: `MIT License (MIT)`

6. Click "Continue"

7. In the next screen:
   - Optimization: Select `Yes`
   - Copy and paste the entire contents of your flattened contract into the "Contract Code" field

8. Complete the captcha if presented

9. Click "Verify and Publish"

If successful, your contract source code will now be visible and verified on Basescan.

## Interacting with the Contract

### Minting an NFT manually

Using `cast` (replace `$CONTRACT_ADDRESS` with your deployed contract address):

```shell
cast send $CONTRACT_ADDRESS "mint()" --value 0.0025ether --rpc-url $RPC_URL --private-key $PRIVATE_KEY
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
