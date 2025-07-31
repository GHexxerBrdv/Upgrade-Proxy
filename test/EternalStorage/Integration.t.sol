// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {EternalData} from "../../src/EternalStorage/DataStorage.sol";
import {LogicV1} from "../../src/EternalStorage/LogicV1.sol";
import {LogicV2} from "../../src/EternalStorage/LogicV2.sol";
import {EtenalDataScript} from "../../script/EternalStorage/DataStorage.s.sol";
import {LogicV1Script} from "../../script/EternalStorage/LogicV1.s.sol";
import {LogicV2Script} from "../../script/EternalStorage/LogicV2.s.sol";

contract IntegrationTest is Test {
    EternalData public data;
    LogicV1 public logic1;
    LogicV2 public logic2;

    EtenalDataScript public dataScript;
    LogicV1Script public logic1Script;
    LogicV2Script public logic2Script;

    address user = makeAddr("user");

    function setUp() public {
        data = new EternalData();
        logic1 = new LogicV1(address(data));
        logic2 = new LogicV2(address(data));
    }

    function test_construction() public view {
        console2.log("the address of eternal data contract is: ", address(data));
        console2.log("the address of logic1 contract is: ", address(logic1));
        console2.log("the address of logic2 contract is: ", address(logic2));
    }

    function test_setUint() public {
        vm.startPrank(user);
        logic1.setUintValue(5);

        uint256 value1 = logic1.getUintValue();
        uint256 value2 = logic2.getUintValue();
        vm.stopPrank();

        assertEq(value1, 5);
        assertEq(value2, 5);
    }

    function test_setAddress() public {
        vm.startPrank(user);
        logic1.setAddressValue(address(this));

        address value1 = logic1.getAddressValue();
        address value2 = logic2.getAddressValue();
        vm.stopPrank();

        assertEq(value1, address(this));
        assertEq(value2, address(this));
    }

    function test_setBool() public {
        vm.startPrank(user);
        logic1.setBoolValue(true);

        bool value1 = logic1.getBoolValue();
        bool value2 = logic2.getBoolValue();
        vm.stopPrank();

        assertEq(value1, true);
        assertEq(value2, true);
    }

    function test_IncreaseUint() public {
        vm.startPrank(user);
        logic1.setUintValue(5);

        uint256 value1 = logic1.getUintValue();
        uint256 value2 = logic2.getUintValue();
        vm.stopPrank();

        assertEq(value1, 5);
        assertEq(value2, 5);

        vm.startPrank(user);
        logic2.increaseBalance(10);

        value1 = logic1.getUintValue();
        value2 = logic2.getUintValue();
        vm.stopPrank();

        assertEq(value1, 15);
        assertEq(value2, 15);
    }
}
