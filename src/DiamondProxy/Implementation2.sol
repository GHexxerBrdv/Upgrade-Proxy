// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Multiply {
    function multiply(uint256 x, uint256 y) external pure returns (uint256 z) {
        z = x * y;
    }

    // selector: 0x2f8cd8b1
    function exponent(uint256 x, uint256 y) external pure returns (uint256 z) {
        z = x ** y;
    }
}
