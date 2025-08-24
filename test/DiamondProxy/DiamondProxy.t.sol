// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {Add} from "../../src/DiamondProxy/Implementation1.sol";
import {Multiply} from "../../src/DiamondProxy/Implementation2.sol";
import {Diamond} from "../../src/DiamondProxy/DiamondProxy.sol";
import {DiamondCut, IDiamondCut} from "../../src/DiamondProxy/DiamondCut.sol";
import {DiamondLoupFacet} from "../../src/DiamondProxy/DiamondLoupFacet.sol";

contract DiamondProxyTeat is Test {
    Add public impl1;
    Multiply public impl2;
    Diamond public proxy;
    DiamondCut public cut;
    DiamondLoupFacet public loupe;

    function setUp() public {
        impl1 = new Add();
        impl2 = new Multiply();
        cut = new DiamondCut();
        loupe = new DiamondLoupFacet();
        proxy = new Diamond(address(this), address(cut));

        bytes4[] memory loupeSelector = new bytes4[](4);
        loupeSelector[0] = DiamondLoupFacet.facetAddress.selector;
        loupeSelector[1] = DiamondLoupFacet.facetAddresses.selector;
        loupeSelector[2] = DiamondLoupFacet.facetFunctionSelector.selector;
        loupeSelector[3] = DiamondLoupFacet.facets.selector;

        bytes4[] memory addSelector = new bytes4[](1);
        addSelector[0] = Add.add.selector;

        bytes4[] memory multiplySelector = new bytes4[](2);
        multiplySelector[0] = Multiply.multiply.selector;
        multiplySelector[1] = Multiply.exponent.selector;

        IDiamondCut.FacetCutAction action = IDiamondCut.FacetCutAction.Add;
        IDiamondCut.FacetCut[] memory facetCut = new IDiamondCut.FacetCut[](3);
        facetCut[0] =
            IDiamondCut.FacetCut({facetAddress: address(loupe), action: action, functionSelectors: loupeSelector});

        facetCut[1] =
            IDiamondCut.FacetCut({facetAddress: address(impl1), action: action, functionSelectors: addSelector});

        facetCut[2] =
            IDiamondCut.FacetCut({facetAddress: address(impl2), action: action, functionSelectors: multiplySelector});

        DiamondCut(address(proxy)).diamondCut(facetCut, address(0), "");
    }

    function test_facet() public view {
        address addresses = DiamondLoupFacet(address(proxy)).facetAddress(Add.add.selector);
        console2.log("the facet address is:", addresses);
        assertEq(address(impl1), addresses);
    }

    function test_facetSelectors() public view {
        bytes4[] memory addSelectors = DiamondLoupFacet(address(proxy)).facetFunctionSelector(address(impl1));
        bytes4[] memory mulSelectors = DiamondLoupFacet(address(proxy)).facetFunctionSelector(address(impl2));
        assertEq(Add.add.selector, addSelectors[0]);
        assertEq(Multiply.multiply.selector, mulSelectors[0]);
        assertEq(Multiply.exponent.selector, mulSelectors[1]);
    }

    function test_facets() public view {
        address[] memory facetsAddress = DiamondLoupFacet(address(proxy)).facets();
        assertEq(address(cut), facetsAddress[0]);
        assertEq(address(loupe), facetsAddress[1]);
        assertEq(address(impl1), facetsAddress[2]);
        assertEq(address(impl2), facetsAddress[3]);
    }
}
