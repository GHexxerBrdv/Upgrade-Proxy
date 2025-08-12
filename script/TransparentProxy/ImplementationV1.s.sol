// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {ImplementationV1} from "../../src/TransparentProxy/ImplementationV1.sol";

contract ImplementationV1Script is Script {
    function run() external returns (ImplementationV1) {
        vm.startBroadcast();
        ImplementationV1 implV1 = new ImplementationV1("name", "symbol");
        vm.stopBroadcast();
        return implV1;
    }
}
