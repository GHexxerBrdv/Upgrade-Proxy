// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console2} from "forge-std/Script.sol";
import {LogicV2} from "../../src/EternalStorage/LogicV2.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract EtenalDataScript is Script {

    function run() external returns(LogicV2) {
        address eternalDataDeploymentAddress = DevOpsTools.get_most_recent_deployment("EternalData", block.chainid);
        vm.startBroadcast();
        LogicV2 data = new LogicV2(eternalDataDeploymentAddress);
        vm.stopBroadcast();
        
        return data;
    }
}