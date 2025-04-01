// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

contract ValidateEnvScript is Script {
    function setUp() public {}

    function run() public {
        // Get the private key from environment
        string memory rawKey = vm.envString("PRIVATE_KEY");
        uint256 deployerPrivateKey;
        
        console.log("Validating environment setup...");
        
        // Check if private key exists
        require(bytes(rawKey).length > 0, "PRIVATE_KEY not found in environment. Make sure you've created and sourced your .env file.");
        
        // If key doesn't start with 0x, add it
        if (bytes(rawKey)[0] != "0" || bytes(rawKey)[1] != "x") {
            deployerPrivateKey = vm.parseUint(string.concat("0x", rawKey));
        } else {
            deployerPrivateKey = vm.parseUint(rawKey);
        }
        
        // Derive the address from the private key
        address deployer = vm.addr(deployerPrivateKey);
        
        // Validate the address format (basic check)
        require(deployer != address(0), "Invalid private key format. Address derived is 0x0.");
        
        // Check RPC URL
        string memory rpcUrl = vm.envString("RPC_URL");
        require(bytes(rpcUrl).length > 0, "RPC_URL not found in environment. Make sure you've created and sourced your .env file.");
        
        // If all checks pass
        console.log("Environment validation successful!");
        console.log("Deployer address:", deployer);
        console.log("RPC URL configured:", rpcUrl);
        
        // Optionally check the balance on the target network
        console.log("");
        console.log("To check your balance on the Base network, run:");
        console.log("cast balance", deployer, "--rpc-url $RPC_URL");
    }
}