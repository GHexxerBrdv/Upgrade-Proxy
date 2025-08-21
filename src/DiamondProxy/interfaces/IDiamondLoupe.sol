// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDiamondLoupe {
    struct Facet {
        address facetAddress;
        bytes4[] functionSelectors;
    }

    function facetAddress(bytes4 selector) external view returns (address);
    function facetAddresses() external view returns (address[] memory);
    function facetFunctionSelector(address _facet) external view returns (bytes4[] memory);
    function facets() external view returns (address[] memory);
}
