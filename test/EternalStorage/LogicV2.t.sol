// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {LogicV2} from "../../src/EternalStorage/LogicV2.sol";
import {EternalData} from "../../src/EternalStorage/DataStorage.sol";

contract LogicV2Test is Test {
    LogicV2 public logic;
    EternalData public data;
    bytes32 public key = keccak256("logic2");

    function setUp() public {
        data = new EternalData();
        logic = new LogicV2(address(data));
    }

    function test_construction() public view {
        assert(address(data) != address(0));
        console2.log("the address if the logic contract is: ", address(logic));
    }

    function test_setUint() public {
        address user = makeAddr("user");

        vm.startPrank(user);
        logic.setUintValue(5);

        uint256 value = logic.getUintValue();
        vm.stopPrank();

        assertEq(value, 5);
    }

    function test_setAddress() public {
        address user = makeAddr("user");

        vm.startPrank(user);
        logic.setAddressValue(address(this));

        address value = logic.getAddressValue();
        vm.stopPrank();

        assertEq(value, address(this));
    }

    function test_setBool() public {
        address user = makeAddr("user");

        vm.startPrank(user);
        logic.setBoolValue(true);

        bool value = logic.getBoolValue();
        vm.stopPrank();

        assertEq(value, true);
    }

    function test_increaseBalance() public {
        address user = makeAddr("user");

        vm.startPrank(user);
        logic.increaseBalance(10);

        uint256 value = logic.getUintValue();
        vm.stopPrank();

        assertEq(value, 10);
    }
}
