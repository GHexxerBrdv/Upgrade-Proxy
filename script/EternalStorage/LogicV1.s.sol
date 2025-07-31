// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console2} from "forge-std/Script.sol";
import {LogicV1} from "../../src/EternalStorage/LogicV1.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract EtenalDataScript is Script {

    function run() external returns(LogicV1) {
        address eternalDataDeploymentAddress = DevOpsTools.get_most_recent_deployment("EternalData", block.chainid);
        vm.startBroadcast();
        LogicV1 data = new LogicV1(eternalDataDeploymentAddress);
        vm.stopBroadcast();
        
        return data;
    }
}