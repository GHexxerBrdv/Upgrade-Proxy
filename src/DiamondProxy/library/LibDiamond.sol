// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDiamondCut} from "../interfaces/IDiamondCut.sol";

library LibDiamond {
    // Diamond storage position.
    bytes32 internal constant DIAMOND_STORAGE_POSITION = keccak256("diamond.standard.diamond.storage");

    struct FacetAddressAndSelectorPosition {
        address facetAddress;
        uint96 selectorPosition;
    }

    struct DiamondStorage {
        mapping(bytes4 => FacetAddressAndSelectorPosition) selectorToFacetAndPos;
        bytes4[] selectors;
        // mapping(address => uint256) facetFunctionCount;
        address contractOwner;
    }

    event DiamondCut(IDiamondCut.FacetCut[] _diamondCut, address _init, bytes _calldata);
    event OwnershipTransferred(address oldOwner, address newOwner);

    function diamondStorage() internal pure returns (DiamondStorage storage ds) {
        bytes32 position = DIAMOND_STORAGE_POSITION;
        assembly {
            ds.slot := position
        }
    }

    function setContractOwner(address _owner) internal {
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

    function diamondCut(IDiamondCut.FacetCut[] memory _diamondCut, address _init, bytes memory _calldata) internal {
        for (uint256 i; i < _diamondCut.length; i++) {
            IDiamondCut.FacetCutAction action = _diamondCut[i].action;
            if (action == IDiamondCut.FacetCutAction.Add) {
                addFunctions(_diamondCut[i].facetAddress, _diamondCut[i].functionSelectors);
            } else if (action == IDiamondCut.FacetCutAction.Replace) {
                replaceFunctions(_diamondCut[i].facetAddress, _diamondCut[i].functionSelectors);
            } else if (action == IDiamondCut.FacetCutAction.Remove) {
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

    function replaceFunctions(address facet, bytes4[] memory functionSelectors) internal {
        if (facet == address(0)) {
            revert("Zero address");
        }

        DiamondStorage storage ds = diamondStorage();
        for (uint256 i = 0; i < functionSelectors.length; i++) {
            bytes4 sel = functionSelectors[i];
            address oldFacet = ds.selectorToFacetAndPos[sel].facetAddress;
            if (oldFacet == address(0)) {
                revert("Facet missing");
            }

            if (oldFacet == facet) {
                revert("Same facet");
            }

            ds.selectorToFacetAndPos[sel].facetAddress = facet;
        }
    }

    function removeFunctions(bytes4[] memory functionSelectors) internal {
        DiamondStorage storage ds = diamondStorage();

        for (uint256 i = 0; i < functionSelectors.length; i++) {
            bytes4 sel = functionSelectors[i];
            FacetAddressAndSelectorPosition storage old = ds.selectorToFacetAndPos[sel];
            if (old.facetAddress == address(0)) {
                revert("Missing facet address");
            }

            uint256 last = ds.selectors.length - 1;
            bytes4 lastSel = ds.selectors[last];
            ds.selectors[old.selectorPosition] = lastSel;
            ds.selectorToFacetAndPos[lastSel].selectorPosition = old.selectorPosition;
            ds.selectors.pop();
            delete ds.selectorToFacetAndPos[lastSel];
        }
    }

    function initializeDiamondCut(address _init, bytes memory _calldata) internal {
        if (_init == address(0)) {
            if (_calldata.length > 0) {
                revert("Init is zero and calldata is non-empty");
            }
        } else {
            (bool ok,) = _init.delegatecall(_calldata);

            if (!ok) {
                revert("Init failed");
            }
        }
    }
}
