// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Beacon} from "../../src/BeaconProxy/Beacon.sol";
// import {IBeacon} from "../../src/BeaconProxy/interfaces/IBeacon.sol";

contract BeaconTest is Test {
    Beacon public beacon;

    address public addr = makeAddr("beacon");
    address public admin = makeAddr("admin");

    function setUp() public {
        beacon = new Beacon(addr, admin);
    }

    function test_getImpl() public view {
        address impl = (beacon).getImplementation();

        assertEq(addr, impl);
    }

    function test_updateImplRevert(address impl) public {
        vm.expectRevert("Not Owner");
        beacon.updateImpl(impl);
    }

    function test_updateImpl(address impl) public {
        vm.prank(admin);
        beacon.updateImpl(impl);

        assertEq(impl, beacon.getImplementation());
    }
}
