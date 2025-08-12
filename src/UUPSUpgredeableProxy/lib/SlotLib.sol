// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SlotLib {
    function readSlot(bytes32 slot) internal view returns (address addr) {
        assembly {
            addr := sload(slot)
        }
    }

    function setSlot(bytes32 slot, address addr) internal {
        assembly {
            sstore(slot, addr)
        }
    }
}
