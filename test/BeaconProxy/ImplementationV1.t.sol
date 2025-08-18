// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {ImplementationV1} from "../../src/BeaconProxy/ImplementationV1.sol";

contract DoMathTest is Test {
    ImplementationV1 public impl;

    function setUp() public {
        impl = new ImplementationV1();
        impl.initialize(5, 5);
    }

    function test_doMathAdd() public view {
        uint256 result = impl.doMath("add");

        assertEq(result, impl.x() + impl.y());
    }

    function test_doMathMul() public view {
        uint256 result = impl.doMath("mul");

        assertEq(result, impl.x() * impl.y());
    }
}
