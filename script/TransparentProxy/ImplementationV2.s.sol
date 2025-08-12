// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {ImplementationV2} from "../../src/TransparentProxy/ImplementationV2.sol";

contract ImplementationV2Script is Script {
    function run() external returns (ImplementationV2) {
        vm.startBroadcast();
        ImplementationV2 implV2 = new ImplementationV2("name", "symbol");
        vm.stopBroadcast();
        return implV2;
    }
}
