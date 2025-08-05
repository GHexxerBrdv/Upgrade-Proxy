// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {EternalProxy} from "../../src/EternalStorage/EternalProxy.sol";
import {LogicV1} from "../../src/EternalStorage/LogicV1.sol";
import {LogicV2} from "../../src/EternalStorage/LogicV2.sol";
import {EternalData} from "../../src/EternalStorage/DataStorage.sol";

contract proxyTest is Test {
    EternalData public data;
    LogicV1 public logicV1;
    LogicV2 public logicV2;
    EternalProxy public proxy;

    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");

    function setUp() public {
        data = new EternalData();
        logicV1 = new LogicV1(address(data));
        logicV2 = new LogicV2(address(data));
        proxy = new EternalProxy(address(logicV1), address(data));
    }

    function test_construction() public view {
        console2.log("the data storage contract address is:", address(data));
        console2.log("the logicV! contract address is:", address(logicV1));
        console2.log("the logicV2 contract address is:", address(logicV2));
        console2.log("the proxy contract address is:", address(proxy));

        address logicAddress = proxy.implementation();
        address dataAddress = logicV1.storageContract();

        assertEq(logicAddress, address(logicV1));
        assertEq(dataAddress, address(data));
    }

    function test_changeLogicProxy() public {
        address oldImpl = proxy.implementation();

        proxy.changeImplementation(address(logicV2));

        address newImpl = proxy.implementation();

        assertFalse(oldImpl == newImpl);
    }

    function test_revertZeroChangeLogicProxy() public {
        vm.expectRevert(EternalProxy.EternalProxy__ZeroAddress.selector);
        proxy.changeImplementation(address(0));
    }

    function test_callLogic() public {
        uint256 value = 14;
        bytes memory functionData = abi.encodeWithSelector(LogicV1.setUintValue.selector, value);

        (bool ok, bytes memory data) = address(proxy).call{value: 0}(functionData);

        uint256 setValue = logicV1.getUintValue();

        assertEq(value, setValue);
    }
}
