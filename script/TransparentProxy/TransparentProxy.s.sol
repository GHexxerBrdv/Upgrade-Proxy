// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {TransparentProxy} from "../../src/TransparentProxy/TransparentProxy.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract TransparentProxyScript is Script {
    function run() external returns (TransparentProxy) {
        address implementationAddress = DevOpsTools.get_most_recent_deployment("ImplementationV1Script", block.chainid);
        vm.startBroadcast();
        TransparentProxy proxy = new TransparentProxy(implementationAddress, 0xA7407106D3c9a5ab2131a7AcAa343b6219Aa1Dd6);
        vm.stopBroadcast();
        return proxy;
    }
}
