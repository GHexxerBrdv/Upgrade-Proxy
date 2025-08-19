// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library LibDiamond {
    // Diamond storage position.
    bytes32 internal constant DIAMONT_STORAGE_POSITION = keccak256("diamond.standard.diamond.storage");

    struct FacetAddressAndSelectorPosition {
        address facetAddress;
        uint96 selectorPosition;
    }

    struct DiamondStorage {
        mapping(bytes4 => FacetAddressAndSelectorPosition) selectorToFacetAndPos;
        bytes4[] selectors;
        mapping(address => uint256) facetFunctionCount;
        address contractOwner;
    }

    event DiamondCut(FacetCut[] _diamondCut, address _init, bytes _calldata);
    event OwnershipTransferred(address oldOwner, address newOwner);

    enum FacetCutAction {
        Add,
        Replace,
        Remove
    }

    struct FacetCut {
        address facetAddress;
        FacetCutAction action;
        bytes4[] functionSelectors;
    }

    function diamondStorage() internal pure returns (DiamondStorage storage ds) {
        bytes32 position = DIAMONT_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }
    }

    function steContractOwner(address _owner) internal {
        DiamondStorage storage ds = diamondStorage();

        address oldOwner = ds.contractOwner;
        ds.contractOwner = _owner;
        emit OwnershipTransferred(oldOwner, _owner);
    }

    function enforceIsContactOwner() internal view {
        if (msg.sender != diamondStorage().contractOwner) {
            revert("Not an Owner");
        }
    }

    function diamondCut(FacetCut[] memory _diamondCut, address _init, bytes memory _calldata) internal {
        for (uint256 i; i < _diamondCut.length; i++) {
            FacetCutAction action = _diamondCut[i].action;
            if (action == FacetCutAction.Add) {
                addFunctions(_diamondCut[i].facetAddress, _diamondCut[i].functionSelectors);
            } else if (action == FacetCutAction.Replace) {
                replaceFunctions(_diamondCut[i].facetAddress, _diamondCut[i].functionSelectors);
            } else if (action == FacetCutAction.Remove) {
                removeFunctions(_diamondCut[i].functionSelectors);
            } else {
                revert("Invalid action");
            }
        }
        emit DiamondCut(_diamondCut, _init, _calldata);
        initializeDiamondCut(_init, _calldata);
    }

    function addFunctions(address facet, bytes4[] memory functionSelectors) internal {
        if (facet == address(0)) {
            revert("Zero address");
        }

        DiamondStorage storage ds = diamondStorage();
        for (uint256 i = 0; i < functionSelectors.length; i++) {
            bytes4 sel = functionSelectors[i];

            if (ds.selectorToFacetAndPos[sel].facetAddress != address(0)) {
                revert("Selector exists");
            }

            ds.selectorToFacetAndPos[sel] = FacetAddressAndSelectorPosition(facet, uint96(ds.selectors.length));
            ds.selectors.push(sel);
        }
    }

    function replaceFunctions(address facet, bytes4[] memory functionSelectors) internal {}

    function removeFunctions(bytes4[] memory functionSelectors) internal {}

    function initializeDiamondCut(address _init, bytes memory _calldata) internal {}
}
