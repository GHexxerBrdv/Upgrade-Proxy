// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {ImplementationV2} from "../../src/BeaconProxy/ImplementationV2.sol";

contract DoMathTestV2 is Test {
    ImplementationV2 public impl;

    function setUp() public {
        impl = new ImplementationV2(5, 7);
    }

    function test_doMathAdd() public view {
        uint256 result = impl.doMath("add");

        assertEq(result, impl.x() + impl.y());
    }

    function test_doMathMul() public view {
        uint256 result = impl.doMath("mul");

        assertEq(result, impl.x() * impl.y());
    }

    function test_doMathSub() public view {
        uint256 result = impl.doMath("sub");

        assertEq(result, impl.y() - impl.x());
    }
}
