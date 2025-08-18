// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {SlotLib} from "./lib/SlotLib.sol";

contract Beacon {
    using SlotLib for bytes32;

    // bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)
    bytes32 private constant IMPLEMENTATION_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;

    address owner;

    modifier onlyAdmin() {
        if (msg.sender != owner) {
            revert("Not Owner");
        }
        _;
    }

    constructor(address implementation, address admin) {
        owner = admin;
        IMPLEMENTATION_SLOT.setSlot(implementation);
    }

    function updateImpl(address impl) external onlyAdmin {
        IMPLEMENTATION_SLOT.setSlot(impl);
    }

    function getImplementation() external view returns (address) {
        address impl = IMPLEMENTATION_SLOT.readSlot();

        return impl;
    }
}
