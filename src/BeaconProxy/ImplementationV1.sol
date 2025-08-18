// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ImplementationV1 {
    uint256 public x;
    uint256 public y;

    function initialize(uint256 _x, uint256 _y) external {
        x = _x;
        y = _y;
    }

    function doMath(string memory opr) external view returns (uint256) {
        if (keccak256(abi.encodePacked(opr)) == keccak256(abi.encodePacked("add"))) {
            return _add(x, y);
        } else if (keccak256(abi.encodePacked(opr)) == keccak256(abi.encodePacked("mul"))) {
            return _mul(x, y);
        } else {
            revert("invalide operation");
        }
    }

    function _add(uint256 _x, uint256 _y) internal pure returns (uint256) {
        return _x + _y;
    }

    function _mul(uint256 _x, uint256 _y) internal pure returns (uint256) {
        return _x * _y;
    }
}
