// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**
 * @author Gaurang Bharadava
 * @notice Contributors
 * ## Contributors :- bsteve456
 */
contract Proxiable {
    function updateCodeAddress(address newAddress) internal {
        require(
            bytes32(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7)
                == Proxiable(newAddress).proxiableUUID(),
            "Not compatible"
        );
        assembly {
            // solium-disable-line
            sstore(0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7, newAddress)
        }
    }

    function proxiableUUID() public pure returns (bytes32) {
        return 0xc5f16f0fcc639fa48a6947836d9850f504798523bf8c9a3a87d5876cf622bcf7;
    }
}

contract Owned {
    address owner;

    function setOwner(address _owner) internal {
        owner = _owner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner is allowed to perform this action");
        _;
    }
}

contract LibraryLockDataLayout {
    bool public initialized = false;
}

contract LibraryLock is LibraryLockDataLayout {
    // Ensures no one can manipulate the Logic Contract once it is deployed.
    // PARITY WALLET HACK PREVENTION

    modifier delegatedOnly() {
        require(initialized == true, "The library is locked. No direct 'call' is allowed");
        _;
    }

    function _initialize() internal {
        initialized = true;
    }
}

contract CounterV2 is Owned, Proxiable, LibraryLock {
    uint256 public number;

    function initialize() public {
        _initialize();
        setOwner(msg.sender);
    }

    function increment() public {
        number++;
    }

    function decrement() public {
        number--;
    }

    function updateCode(address newCode) public onlyOwner delegatedOnly {
        updateCodeAddress(newCode);
    }
}
