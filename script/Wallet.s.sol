// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import "../src/Wallet.sol";

contract DeployWallet is Script {
    function run() external {
        vm.startBroadcast();

        // Wdrażanie kontraktu
        Wallet wallet = new Wallet();
        console.log("Wallet deployed at:", address(wallet));

        vm.stopBroadcast();
    }
}
