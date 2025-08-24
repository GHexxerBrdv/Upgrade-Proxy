// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDiamondLoupe} from "./interfaces/IDiamondLoupe.sol";
import {LibDiamond} from "./library/LibDiamond.sol";

contract DiamondLoupFacet is IDiamondLoupe {
    function facetAddress(bytes4 selector) external view returns (address) {
        return LibDiamond.diamondStorage().selectorToFacetAndPos[selector].facetAddress;
    }

    function facetAddresses() external view returns (address[] memory) {
        return this.facets();
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
        return out;
    }

    function facets() external view returns (address[] memory) {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        uint256 n = ds.selectors.length;
        address[] memory tmp = new address[](n);

        uint256 fCount;

        for (uint256 i; i < n; i++) {
            address f = ds.selectorToFacetAndPos[ds.selectors[i]].facetAddress;

            bool seen;

            for (uint256 j; j < fCount; j++) {
                if (tmp[j] == f) {
                    seen = true;
                    break;
                }
            }

            if (!seen) {
                tmp[fCount++] = f;
            }
        }

        address[] memory facetAddrs = new address[](fCount);
        for (uint256 i; i < fCount; i++) {
            facetAddrs[i] = tmp[i];
        }

        return facetAddrs;
    }
}
