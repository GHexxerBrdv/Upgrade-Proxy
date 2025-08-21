// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDiamondLoupe} from "./interfaces/IDiamondLoupe.sol";
import {LibDiamond} from "./library/LibDiamond.sol";

contract DiamondLoupFacet is IDiamondLoupe {
    function facetAddress(bytes4 selector) external view returns (address) {
        return LibDiamond.diamondStorage().selectorToFacetAndPos[selector].facetAddress;
    }

    function facetAddresses() external view returns (address[] memory) {
        (address[] memory addresses,) = this.facets();
        return addresses;
    }

    function facetFunctionSelector(address _facet) external view returns (bytes4[] memory) {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        uint256 n = ds.selectors.length;
        uint256 c;
        for (uint256 i; i < n; i++) {
            if (ds.selectorToFacetAndPos[ds.selectors[i]].facetAddress == _facet) c++;
        }
        bytes4[] memory out = new bytes4[](c);
        uint256 idx;
        for (uint256 i; i < n; i++) {
            bytes4 s = ds.selectors[i];
            if (ds.selectorToFacetAndPos[s].facetAddress == _facet) out[idx++] = s;
        }
    }

    function facets() external view returns (address[] memory, bytes4[][] memory) {}
}
