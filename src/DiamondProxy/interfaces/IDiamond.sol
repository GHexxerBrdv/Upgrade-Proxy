// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IDamond {
    enum FacetCutAction {
        ADD,
        Replace,
        Remove
    }

    struct FacetCut {
        address facetAddress;
        FacetCutAction action;
        bytes4[] functionSelectors;
    }

    event DiamondCut(FacetCut[] _diamondCut, address _init, bytes _calldata);
}
