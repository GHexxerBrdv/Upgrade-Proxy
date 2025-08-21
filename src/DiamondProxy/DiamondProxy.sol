// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import {ADD} from "../../src/DiamondProxy/Implementation1.sol";
// import {Multiply} from "../../src/DiamondProxy/Implementation2.sol";
// import {IDamond} from "./interfaces/IDiamond.sol";
import {IDiamondCut} from "./interfaces/IDiamondCut.sol";
import {LibDiamond} from "./library/LibDiamond.sol";

contract Diamond {
    address immutable IMPL1;
    address immutable IMPL2;

    constructor(address _owner, address _cutFacet) {
        if (_owner == address(0)) {
            revert("Zero address");
        }
        LibDiamond.setContractOwner(_owner);

        IDiamondCut.FacetCut[] memory cut = new IDiamondCut.FacetCut[](1);
        bytes4[] memory functionSelectors = new bytes4[](1);

        functionSelectors[0] = IDiamondCut.diamondCut.selector;
        cut[0] = IDiamondCut.FacetCut({
            facetAddress: _cutFacet,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: functionSelectors
        });

        LibDiamond.diamondCut(cut, address(0), "");
    }

    function _fallback() internal {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();

        address facet = ds.selectorToFacetAndPos[msg.sig].facetAddress;

        if (facet == address(0)) {
            revert("Zero Address");
        }

        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), facet, 0, calldatasize(), 0, 0)

            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    fallback() external payable {
        _fallback();
    }

    receive() external payable {
        _fallback();
    }
}
