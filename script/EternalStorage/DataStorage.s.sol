// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console2} from "forge-std/Script.sol";
import {EternalData} from "../../src/EternalStorage/DataStorage.sol";

contract EtenalDataScript is Script {
    function run() external returns (EternalData) {
        vm.startBroadcast();
        EternalData data = new EternalData();
        vm.stopBroadcast();

        return data;
    }
}
