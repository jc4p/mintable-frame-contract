// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {FarcasterNFT} from "../src/FarcasterNFT.sol";
import {console2} from "forge-std/console2.sol";

contract FarcasterNFTScript is Script {
    function setUp() public {}

    function run() public {
        // Verify we're on Base mainnet
        require(block.chainid == 8453, "Must be run on Base mainnet");
        
        string memory rawKey = vm.envString("PRIVATE_KEY");
        uint256 deployerPrivateKey;
        
        // If key doesn't start with 0x, add it
        if (bytes(rawKey)[0] != "0" || bytes(rawKey)[1] != "x") {
            deployerPrivateKey = vm.parseUint(string.concat("0x", rawKey));
        } else {
            deployerPrivateKey = vm.parseUint(rawKey);
        }

        address deployer = vm.addr(deployerPrivateKey);
        console2.log("Deploying from address:", deployer);
        console2.log("Deployer balance:", deployer.balance);
        
        vm.startBroadcast(deployerPrivateKey);

        FarcasterNFT nft = new FarcasterNFT();
        console2.log("FarcasterNFT contract deployed to:", address(nft));
        
        vm.stopBroadcast();
    }
}