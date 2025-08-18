// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {BeaconProxy, IBeacon} from "../../src/BeaconProxy/BeaconProxy.sol";
import {Beacon} from "../../src/BeaconProxy/Beacon.sol";
import {ImplementationV1} from "../../src/BeaconProxy/ImplementationV1.sol";
import {ImplementationV2} from "../../src/BeaconProxy/ImplementationV2.sol";
import {Test} from "forge-std/Test.sol";

contract BeaconProxyTest is Test {
    BeaconProxy public proxy;
    ImplementationV1 public implV1;
    ImplementationV2 public implV2;
    Beacon public beacon;

    function setUp() public {
        bytes memory data = abi.encodeWithSelector(ImplementationV1.initialize.selector, 510, 450);
        implV1 = new ImplementationV1();
        implV2 = new ImplementationV2();
        beacon = new Beacon(address(implV1), address(this));
        proxy = new BeaconProxy(address(beacon), data);
    }

    function test_add() public view {
        string memory opr = "add";

        assertEq(address(implV1), beacon.getImplementation());
        uint256 value = ImplementationV1(address(proxy)).doMath(opr);

        assertEq(value, 510 + 450);
    }

    function test_mul() public view {
        string memory opr = "mul";

        assertEq(address(implV1), beacon.getImplementation());
        uint256 value = ImplementationV1(address(proxy)).doMath(opr);

        assertEq(value, 510 * 450);
    }

    function test_updateImplProxy() public {
        string memory opr = "add";

        assertEq(address(implV1), beacon.getImplementation());
        uint256 value = ImplementationV1(address(proxy)).doMath(opr);

        assertEq(value, 510 + 450);

        beacon.updateImpl(address(implV2));

        assertEq(address(implV2), beacon.getImplementation());

        assertEq(ImplementationV2(address(proxy)).x(), 510);
        assertEq(ImplementationV2(address(proxy)).y(), 450);

        opr = "sub";

        value = ImplementationV2(address(proxy)).doMath(opr);

        assertEq(value, 510 - 450);
    }
}
