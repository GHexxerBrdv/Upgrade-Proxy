// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {EternalData} from "../../EternalStorage/src/DataStorage.sol";

contract EternalStorageTest is Test {
    EternalData data;
    bytes32 key = keccak256("data");

    function setUp() public {
        data = new EternalData();
    }

    function test_Initialization() public view {
        address code = address(data);
        assert(code != address(0));
    }

    function test_setUint() public {
        address user = makeAddr("user");

        vm.startPrank(user);
        key = keccak256(abi.encode(key, msg.sender));
        data.setUint(key, 5);
        data.setAddress(key, address(this));
        data.setBool(key, true);
        vm.stopPrank();

        uint256 value = data.getUint(key);
        address _value = data.getAddress(key);
        bool ok = data.getBool(key);

        assertEq(value, 5);
        assertEq(_value, address(this));
        assertEq(ok, true);
    }
}
