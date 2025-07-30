// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EternalData {

    // Mappings

    mapping(bytes32 => uint256) private uintValue;
    mapping(bytes32 => address) private addressValue;
    mapping(bytes32 => bool) private boolValue;

    // Setter functions

    function setUint(bytes32 _key, uint256 _value) external {
        uintValue[_key] = _value;
    }

    function setAddress(bytes32 _key, address _value) external {
        addressValue[_key] = _value;
    }

    function setBool(bytes32 _key, bool _value) external {
        boolValue[_key] = _value;
    }

    // Getter functions

    function getUint(bytes32 _key) external view returns(uint256) {
        return uintValue[_key];
    }

    function getAddress(bytes32 _key) external view returns(address) {
        return addressValue[_key];
    }

    function getBool(bytes32 _key) external view returns(bool) {
        return boolValue[_key];
    }
}