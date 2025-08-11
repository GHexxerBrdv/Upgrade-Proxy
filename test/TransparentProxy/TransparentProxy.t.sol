// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {ImplementationV1} from "../../src/TransparentProxy/ImplementationV1.sol";
import {ImplementationV2} from "../../src/TransparentProxy/ImplementationV2.sol";
import {TransparentProxy} from "../../src/TransparentProxy/TransparentProxy.sol";

contract TransparentProxyTest is Test {
    TransparentProxy public proxy;
    ImplementationV1 public implV1;
    ImplementationV2 public implV2;

    address admin = makeAddr("admin");

    function setUp() public {
        implV1 = new ImplementationV1("brdv", "brdv");
        implV2 = new ImplementationV2("brdv", "brdv");
        proxy = new TransparentProxy(address(implV1), admin);
    }

    function test_construction() public view {
        console2.log("the implV1 address is:", address(implV1));
        console2.log("the implV2 address is:", address(implV2));
        console2.log("the proxy address is:", address(proxy));

        assertEq(implV1.getName(), "brdv");
        assertEq(implV2.getName(), "brdv");
        assertEq(proxy.getImplementation(), address(implV1));
    }

    function test_mint() public {
        address user = makeAddr("user");

        uint256 amount = 10e18;

        vm.prank(user);
        ImplementationV1(address(proxy)).mint(user, amount);

        uint256 totalSupply = ImplementationV1(address(proxy)).totalSupply();
        assert(totalSupply == 10e18);

        uint256 userBalance = ImplementationV1(address(proxy)).balanceOf(user);
        assert(userBalance == 10e18);
    }

    function test_transfer(uint256 amount) public {
        amount = bound(amount, 10, type(uint256).max);
        address user = makeAddr("user");
        address alice = makeAddr("alice");

        ImplementationV1(address(proxy)).mint(user, amount);

        vm.prank(user);
        ImplementationV1(address(proxy)).transfer(alice, amount / 2);

        uint256 totalSupply = ImplementationV1(address(proxy)).totalSupply();
        assert(totalSupply == amount);

        uint256 expectedaliceBalance = amount / 2;
        uint256 expectedUserBalance = amount - expectedaliceBalance;
        uint256 userBalance = ImplementationV1(address(proxy)).balanceOf(user);
        assert(userBalance == expectedUserBalance);
        uint256 aliceBalance = ImplementationV1(address(proxy)).balanceOf(alice);
        assert(aliceBalance == expectedaliceBalance);
    }

    function test_changeImplAndBurn(uint256 amount) public {
        amount = bound(amount, 10, type(uint256).max);
        address user = makeAddr("user");
        address alice = makeAddr("alice");

        ImplementationV1(address(proxy)).mint(user, amount);

        vm.prank(user);
        ImplementationV1(address(proxy)).transfer(alice, amount / 2);

        uint256 totalSupply = ImplementationV1(address(proxy)).totalSupply();
        assert(totalSupply == amount);

        uint256 expectedaliceBalance = amount / 2;
        uint256 expectedUserBalance = amount - expectedaliceBalance;
        uint256 userBalance = ImplementationV1(address(proxy)).balanceOf(user);
        assert(userBalance == expectedUserBalance);
        uint256 aliceBalance = ImplementationV1(address(proxy)).balanceOf(alice);
        assert(aliceBalance == expectedaliceBalance);

        vm.prank(admin);
        proxy.updateImplementation(address(implV2));

        address impl = proxy.getImplementation();
        assert(impl == address(implV2));

        userBalance = ImplementationV2(address(proxy)).balanceOf(user);
        assert(userBalance == expectedUserBalance);
        aliceBalance = ImplementationV2(address(proxy)).balanceOf(alice);
        assert(aliceBalance == expectedaliceBalance);

        vm.prank(user);
        ImplementationV2(address(proxy)).burn(amount / 2 - 1);

        uint256 totalSupply2 = ImplementationV2(address(proxy)).totalSupply();
        assertGt(totalSupply, totalSupply2);
    }
}
