// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {SlotLib} from "./lib/SlotLib.sol";

/**
 * @title UUPS Proxy
 * @author Gaurang Bharadava
 * @notice Following are contributors github username.
 * ## Contributors :- bsteve456
 */
contract UUPSProxy {
    using SlotLib for bytes32;

    bytes32 public constant IMPLEMENTATION_SLOT = 0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7;

    constructor(bytes memory constructData, address implementation) {
        // save the code address
        // assembly {
        //     // solium-disable-line
        //     sstore(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7, implementation)
        // }
        IMPLEMENTATION_SLOT.setSlot(implementation);
        if (constructData.length > 0) {
            (bool success,) = implementation.delegatecall(constructData); // solium-disable-line
            require(success, "Construction failed");
        }
    }

    fallback() external payable {
        assembly {
            // see erc-1822 standard documentation : https://eips.ethereum.org/EIPS/eip-1822
            let implementation := sload(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7)
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.

            // calldatacopy(t, f, s) - copy s bytes from calldata at position f to mem at position t
            // calldatasize() - size of call data in bytes
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.

            // delegatecall(g, a, in, insize, out, outsize) -
            // - call contract at address a
            // - with input mem[in…(in+insize))
            // - providing g gas
            // - and output area mem[out…(out+outsize))
            // - returning 0 on error (eg. out of gas) and 1 on success
            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)

            // Copy the returned data.
            // returndatacopy(t, f, s) - copy s bytes from returndata at position f to mem at position t
            // returndatasize() - size of the last returndata
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 {
                // revert(p, s) - end execution, revert state changes, return data mem[p…(p+s))
                revert(0, returndatasize())
            }
            default {
                // return(p, s) - end execution, return data mem[p…(p+s))
                return(0, returndatasize())
            }
        }
    }
}
