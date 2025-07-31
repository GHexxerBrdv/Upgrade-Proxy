// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {EternalData} from "./DataStorage.sol";

contract LogicV2 {
    address public storageContract;

    constructor(address _storageContract) {
        storageContract = _storageContract;
    }

    // Setter functions

    function setUintValue(uint256 _value) external {
        bytes32 key = keccak256(abi.encodePacked("setUint", msg.sender));
        EternalData(storageContract).setUint(key, _value);
    }

    function setAddressValue(address _value) external {
        bytes32 key = keccak256(abi.encodePacked("setAddress", msg.sender));
        EternalData(storageContract).setAddress(key, _value);
    }

    function setBoolValue(bool _value) external {
        bytes32 key = keccak256(abi.encodePacked("setBool", msg.sender));
        EternalData(storageContract).setBool(key, _value);
    }

    // New function to add

    function increaseBalance(uint256 _value) external {
        bytes32 key = keccak256(abi.encodePacked("setUint", msg.sender));
        uint256 value = EternalData(storageContract).getUint(key);
        EternalData(storageContract).setUint(key, value + _value);
    }

    // Getter functions

    function getUintValue() external view returns (uint256) {
        bytes32 key = keccak256(abi.encodePacked("setUint", msg.sender));
        return EternalData(storageContract).getUint(key);
    }

    function getAddressValue() external view returns (address) {
        bytes32 key = keccak256(abi.encodePacked("setAddress", msg.sender));
        return EternalData(storageContract).getAddress(key);
    }

    function getBoolValue() external view returns (bool) {
        bytes32 key = keccak256(abi.encodePacked("setBool", msg.sender));
        return EternalData(storageContract).getBool(key);
    }
}
