// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {EternalProxy} from "../../src/EternalStorage/EternalProxy.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract ProxyScript is Script {
    EternalProxy proxy;

    function run() external returns (EternalProxy) {
        address implementation = DevOpsTools.get_most_recent_deployment("LogicV1", block.chainid);
        address eternalData = DevOpsTools.get_most_recent_deployment("EternalData", block.chainid);
        vm.startBroadcast();
        proxy = new EternalProxy(implementation, eternalData);
        vm.stopBroadcast();

        return proxy;
    }
}
