// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {ImplementationV2} from "../../src/TransparentProxy/ImplementationV2.sol";

contract ImplementationV2Test is Test {
    ImplementationV2 public code;

    function setUp() public {
        code = new ImplementationV2("ok", "ok");
    }

    function test_construction() public view {
        console2.log("The contract address is:", address(code));
        console2.log("The token name is:", code.getName());
        console2.log("The token symbol is:", code.getSymbol());
        assert(code.totalSupply() == 0);
    }

    function test_mint() public {
        address user = makeAddr("user");

        code.mint(user, 1500e18);

        assertEq(code.balanceOf(user), 1500e18);
        assertEq(code.totalSupply(), 1500e18);
    }

    function test_transfer() public {
        address user = makeAddr("user");
        address alice = makeAddr("alice");
        address prox = makeAddr("prox");

        code.mint(user, 1500e18);

        vm.prank(user);
        code.approve(address(this), type(uint256).max);

        vm.prank(user);
        code.transfer(alice, 150e18);

        assertEq(code.balanceOf(alice), 150e18);
        assertEq(code.totalSupply(), 1500e18);

        code.transferFrom(user, prox, 200e18);

        assertEq(code.balanceOf(prox), 200e18);
    }
}
