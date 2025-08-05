// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EternalProxy {
    error EternalProxy__ZeroAddress();
    error EternalProxy__InteractionFailed(bytes data);
    error EternalProxy__NotAnOwner(address caller);

    address public storageContract;
    address public implementation;
    address owner;

    event ImplementationChanged(address oldImpl, address newImpl);

    constructor(address impl, address data) {
        storageContract = data;
        implementation = impl;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert EternalProxy__NotAnOwner(msg.sender);
        }
        _;
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

    receive() external payable {}
}
