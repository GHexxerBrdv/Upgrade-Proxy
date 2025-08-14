// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {CounterV1} from "../../../src/UUPSUpgredeableProxy/Implementations/CounterV1.sol";
import {CounterV2} from "../../../src/UUPSUpgredeableProxy/Implementations/CounterV2.sol";
import {UUPSProxy} from "../../../src/UUPSUpgredeableProxy/UUPSProxy.sol";

contract CounterTest is Test {
    CounterV1 public counterV1;
    CounterV2 public counterV2;
    UUPSProxy public proxy;

    function setUp() public {
        bytes memory initSelector = abi.encodeWithSelector(0x8129fc1c);
        counterV1 = new CounterV1();
        counterV2 = new CounterV2();
        proxy = new UUPSProxy(initSelector, address(counterV1));
    }

    function test_fallback() public {
        CounterV1(address(proxy)).increment();
        CounterV1(address(proxy)).increment();
        CounterV1(address(proxy)).increment();
        assertEq(CounterV1(address(proxy)).number(), 3);
    }

    function test_upgrade() public {
        CounterV1(address(proxy)).increment();
        CounterV1(address(proxy)).increment();
        CounterV1(address(proxy)).increment();
        assertEq(CounterV1(address(proxy)).number(), 3);

        // Update proxy implementation from CounterV1 to CounterV2
        CounterV1(address(proxy)).updateCode(address(counterV2));
        CounterV2(address(proxy)).initialize();

        // Check if the proxy stored the modification from the CounterV1 implementation
        assertEq(CounterV2(address(proxy)).number(), 3);

        CounterV2(address(proxy)).decrement();
        CounterV2(address(proxy)).decrement();
        CounterV2(address(proxy)).decrement();

        // Check if the decrement function exclusive to CounterV2 worked
        assertEq(CounterV2(address(proxy)).number(), 0);
    }
}
