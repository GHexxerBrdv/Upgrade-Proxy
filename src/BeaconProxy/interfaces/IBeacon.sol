// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBeacon {
    function updateImpl(address impl) external;
    function getImplementation() external view returns (address);
}
