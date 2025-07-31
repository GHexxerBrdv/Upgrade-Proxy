// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract EternalProxy is Ownable {
    error EternalProxy__ZeroAddress();
    error EternalProxy__InteractionFailed(bytes data);

    address public implementation;

    event ImplementationChanged(address oldImpl, address newImpl);

    constructor(address impl) Ownable(msg.sender) {
        implementation = impl;
    }

    function changeImplementation(address impl) external onlyOwner {
        if (impl == address(0)) {
            revert EternalProxy__ZeroAddress();
        }

        address oldImpl = implementation;

        implementation = impl;

        emit ImplementationChanged(oldImpl, impl);
    }

    fallback(bytes calldata data) external payable returns (bytes memory) {
        (bool ok, bytes memory returnData) = implementation.delegatecall(data);

        if (!ok) {
            revert EternalProxy__InteractionFailed(data);
        }

        return returnData;
    }
}
