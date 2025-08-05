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

    function test_callLogicSetUint() public {
        uint256 value = 14;
        bytes memory functionData = abi.encodeWithSelector(LogicV1.setUintValue.selector, value);

        vm.prank(user1);
        (, bytes memory data) = address(proxy).call{value: 0}(functionData);
        vm.prank(user1);
        uint256 setValue = logicV1.getUintValue();

        assertEq(value, setValue);
    }

    function test_callLogicSetAddress() public {
        bytes memory functionData = abi.encodeWithSelector(LogicV1.setAddressValue.selector, user1);

        vm.prank(user2);
        (, bytes memory data) = address(proxy).call{value: 0}(functionData);
        vm.prank(user2);
        address setValueAddress = logicV1.getAddressValue();

        assertEq(user1, setValueAddress);
    }

    function test_callLogicSetBool() public {
        bytes memory functionData = abi.encodeWithSelector(LogicV1.setBoolValue.selector, true);

        vm.prank(user2);
        (, bytes memory data) = address(proxy).call{value: 0}(functionData);
        vm.prank(user2);
        bool setValueAddress = logicV1.getBoolValue();

        assertEq(true, setValueAddress);
    }

    function test_newImplementationGetUint() public {
        uint256 value = 14;
        bytes memory functionData = abi.encodeWithSelector(LogicV1.setUintValue.selector, value);

        (, bytes memory data) = address(proxy).call{value: 0}(functionData);

        uint256 setValue = logicV1.getUintValue();

        assertEq(value, setValue);

        proxy.changeImplementation(address(logicV2));
        assertEq(address(logicV2), proxy.implementation());

        functionData = abi.encodeWithSelector(LogicV2.getUintValue.selector);
        (, bytes memory _data) = address(proxy).call{value: 0}(functionData);

        uint256 _value = abi.decode(_data, (uint256));

        console2.log("the value is:", _value);

        assertEq(_value, value);
    }

    function test_newImplementationSetUint() public {
        uint256 value = 14;
        bytes memory functionData = abi.encodeWithSelector(LogicV1.setUintValue.selector, value);

        (, bytes memory data) = address(proxy).call{value: 0}(functionData);

        uint256 setValue = logicV1.getUintValue();

        assertEq(value, setValue);

        proxy.changeImplementation(address(logicV2));
        assertEq(address(logicV2), proxy.implementation());

        functionData = abi.encodeWithSelector(LogicV2.getUintValue.selector);
        (, bytes memory _data) = address(proxy).call{value: 0}(functionData);

        uint256 _value = abi.decode(_data, (uint256));

        assertEq(_value, value);

        value = 500;

        functionData = abi.encodeWithSelector(LogicV2.setUintValue.selector, value);

        (, data) = address(proxy).call(functionData);

        functionData = abi.encodeWithSelector(LogicV2.getUintValue.selector);
        (, _data) = address(proxy).call{value: 0}(functionData);

        _value = abi.decode(_data, (uint256));

        assertEq(_value, value);

        functionData = abi.encodeWithSelector(LogicV1.getUintValue.selector);
        (, _data) = address(proxy).call{value: 0}(functionData);

        _value = abi.decode(_data, (uint256));

        assertEq(_value, value);
    }

    function test_newImplementationSetAddressUint() public {
        bytes memory functionData = abi.encodeWithSelector(LogicV1.setAddressValue.selector, user1);

        (, bytes memory data) = address(proxy).call{value: 0}(functionData);

        address setValue = logicV1.getAddressValue();

        assertEq(user1, setValue);

        proxy.changeImplementation(address(logicV2));
        assertEq(address(logicV2), proxy.implementation());

        functionData = abi.encodeWithSelector(LogicV2.getAddressValue.selector);
        (, bytes memory _data) = address(proxy).call{value: 0}(functionData);

        address _value = abi.decode(_data, (address));

        assertEq(_value, user1);

        functionData = abi.encodeWithSelector(LogicV2.setAddressValue.selector, user2);

        (, data) = address(proxy).call(functionData);

        functionData = abi.encodeWithSelector(LogicV2.getAddressValue.selector);
        (, _data) = address(proxy).call{value: 0}(functionData);

        _value = abi.decode(_data, (address));

        assertEq(_value, user2);

        functionData = abi.encodeWithSelector(LogicV1.getAddressValue.selector);
        (, _data) = address(proxy).call{value: 0}(functionData);

        _value = abi.decode(_data, (address));

        assertEq(_value, user2);
    }

    function test_newImplementationSetBoolUint() public {
        bytes memory functionData = abi.encodeWithSelector(LogicV1.setBoolValue.selector, true);

        (, bytes memory data) = address(proxy).call{value: 0}(functionData);

        bool setValue = logicV1.getBoolValue();

        assertEq(true, setValue);

        proxy.changeImplementation(address(logicV2));
        assertEq(address(logicV2), proxy.implementation());

        functionData = abi.encodeWithSelector(LogicV2.getBoolValue.selector);
        (, bytes memory _data) = address(proxy).call{value: 0}(functionData);

        bool _value = abi.decode(_data, (bool));

        assertEq(_value, true);

        functionData = abi.encodeWithSelector(LogicV2.setBoolValue.selector, false);

        (, data) = address(proxy).call(functionData);

        functionData = abi.encodeWithSelector(LogicV2.getAddressValue.selector);
        (, _data) = address(proxy).call{value: 0}(functionData);

        _value = abi.decode(_data, (bool));

        assertEq(_value, false);

        functionData = abi.encodeWithSelector(LogicV1.getAddressValue.selector);
        (, _data) = address(proxy).call{value: 0}(functionData);

        _value = abi.decode(_data, (bool));

        assertEq(_value, false);
    }

    function test_InteractionFailes() public {
        bytes memory data = abi.encode(address(0));

        vm.expectRevert(EternalProxy.EternalProxy__InteractionFailed.selector);
        address(proxy).call(data);
    }
}
