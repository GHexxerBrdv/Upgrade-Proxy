// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Transparent Proxy contract
 * @author Gaurang Bharadava
 * @notice the proxy contract which redirect the user call to the appropriate implementation contract.
 * @notice This contract is only for educational purpose, do not use it in production.
 */
import {SlotLib} from "./lib/SlotLib.sol";

contract TransparentProxy {
    using SlotLib for bytes32;

    error TransparentProxy__transactionFailed(bytes data);
    error TransparentProxy__notAnAdmin(address caller);
    error TransparentProxy__zeroAddress();
    error TransparentProxy__adminCanNotCall();

    bytes32 private constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    bytes32 private constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
    // address private implementation; using this is recommended
    // address private admin; using this is not recommended

    constructor(address _implementation, address initialAdmin) {
        if (_implementation == address(0) || initialAdmin == address(0)) {
            revert TransparentProxy__zeroAddress();
        }
        ADMIN_SLOT.setSlot(initialAdmin);
        IMPLEMENTATION_SLOT.setSlot(_implementation);

        // These are not recommended
        // implementation = _implementationm;
        // admin = msg.sender;
    }

    modifier onlyAdmin() {
        if (msg.sender != _getAdmin()) {
            revert TransparentProxy__notAnAdmin(msg.sender);
        }
        _;
    }

    function getImplementation() external view returns (address) {
        return _getImplementation();
    }

    function getAdmin() external view returns (address) {
        return _getAdmin();
    }

    function updateImplementation(address _implementation) external onlyAdmin {
        if (_implementation == address(0)) {
            revert TransparentProxy__zeroAddress();
        }
        IMPLEMENTATION_SLOT.setSlot(_implementation);
    }

    function _fallback() internal {
        if (msg.sender == _getAdmin()) {
            revert TransparentProxy__adminCanNotCall();
        }

        address implementation = _getImplementation();
        (bool ok, bytes memory data) = implementation.delegatecall(msg.data);

        if (!ok) {
            revert TransparentProxy__transactionFailed(data);
        }
    }

    function _getImplementation() internal view returns (address impl) {
        return IMPLEMENTATION_SLOT.readSlot();
    }

    function _getAdmin() internal view returns (address admin) {
        return ADMIN_SLOT.readSlot();
    }

    fallback() external payable {
        _fallback();
    }

    receive() external payable {
        _fallback();
    }
}
