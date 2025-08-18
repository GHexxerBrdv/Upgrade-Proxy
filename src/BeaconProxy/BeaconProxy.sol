// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IBeacon} from "./interfaces/IBeacon.sol";

contract BeaconProxy {
    address private immutable beacon;

    constructor(address _beacon, bytes memory initialData) {
        beacon = _beacon;

        if (initialData.length > 0) {
            (bool success,) = _implementation().delegatecall(initialData); // solium-disable-line
            require(success, "Construction failed");
        }
    }

    function _getBeacon() internal view returns (address) {
        return beacon;
    }

    function _implementation() internal view returns (address) {
        address impl = IBeacon(_getBeacon()).getImplementation();

        return impl;
    }

    function _fallback() internal returns (bytes memory) {
        address impl = _implementation();

        (bool ok, bytes memory data) = impl.delegatecall(msg.data);

        if (!ok) {
            revert("Transaction failed");
        }

        return data;
    }

    fallback(bytes calldata /* data */ ) external payable returns (bytes memory) {
        return _fallback();
    }

    receive() external payable {
        _fallback();
    }
}
