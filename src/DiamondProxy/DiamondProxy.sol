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

    // struct Facet {
    //     address facetAddress;
    //     bytes4[] functionSelectors;
    // }

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
    // constructor(address impl1, address impl2) {
    //     IMPL1 = impl1;
    //     IMPL2 = impl2;

    //     FacetCut[] memory _diamondCuts = new FacetCut[](3);

    //     _diamondCuts[0].facetAddress = IMPL1;
    //     bytes4[] memory _addFacets = new bytes4[](1);
    //     _addFacets[0] = Add.add.selector;

    //     // add to _diamondCuts
    //     _diamondCuts[0].action = FacetCutAction.ADD;
    //     _diamondCuts[0].functionSelectors = _addFacets;

    //     _diamondCuts[1].facetAddress = IMPL2;
    //     bytes4[] memory _mulFacets = new bytes4[](2);
    //     _mulFacets[0] = Multiply.multiply.selector;
    //     _mulFacets[1] = Multiply.exponent.selector;

    //     // add to _diamondCuts
    //     _diamondCuts[1].action = FacetCutAction.ADD;
    //     _diamondCuts[1].functionSelectors = _mulFacets;

    //     // Note that the IDiamondLoupe interface functions are also logged.
    //     _diamondCuts[2].facetAddress = address(this);
    //     bytes4[] memory _loupeFacets = new bytes4[](4);
    //     _loupeFacets[0] = this.facetAddress.selector;
    //     _loupeFacets[1] = this.facetAddresses.selector;
    //     _loupeFacets[2] = this.facets.selector;
    //     _loupeFacets[3] = this.facetFunctionSelectors.selector;

    //     // add to _diamondCuts
    //     _diamondCuts[2].action = FacetCutAction.ADD;
    //     _diamondCuts[2].functionSelectors = _loupeFacets;

    //     emit DiamondCut(_diamondCuts, address(0), "");
    // }

    // function facetAddress(bytes4 selector) public view returns (address) {
    //     if (selector == Add.add.selector) {
    //         return IMPL1;
    //     } else if (selector == Multiply.multiply.selector || selector == Multiply.exponent.selector) {
    //         return IMPL2;
    //     } else {
    //         return address(0);
    //     }
    // }

    // function facetAddresses() public view returns (address[] memory) {
    //     address[] memory facetAdds;
    //     facetAdds[0] = IMPL1;
    //     facetAdds[1] = IMPL2;

    //     return facetAdds;
    // }

    // function facetFunctionSelectors(address _facet) public view returns (bytes4[] memory) {
    //     if (_facet == address(0)) {
    //         revert("Zero Address");
    //     }

    //     if (_facet == IMPL1) {
    //         bytes4[] memory facetSelectors = new bytes4[](1);

    //         facetSelectors[0] = Add.add.selector;

    //         return facetSelectors;
    //     } else if (_facet == IMPL2) {
    //         bytes4[] memory facetSelectors = new bytes4[](2);

    //         facetSelectors[0] = Multiply.multiply.selector;
    //         facetSelectors[1] = Multiply.exponent.selector;

    //         return facetSelectors;
    //     } else {
    //         bytes4[] memory facetSelectors = new bytes4[](0);

    //         return facetSelectors;
    //     }
    // }

    // function facets() public view returns (Facet[] memory) {
    //     address[] memory fa = facetAddresses();
    //     Facet[] memory _facets = new Facet[](2);

    //     for (uint256 i = 0; i < fa.length; i++) {
    //         _facets[i].facetAddress = fa[i];
    //         _facets[i].functionSelectors = facetFunctionSelectors(fa[i]);
    //     }

    //     return _facets;
    // }

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
