// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BeaconProxy {
    address public immutable beacon;

    constructor(address _beacon) {
        beacon = _beacon;
    }
}
