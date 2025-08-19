// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Add} from "../../src/DiamondProxy/Implementation1.sol";
import {Multiply} from "../../src/DiamondProxy/Implementation2.sol";

contract Diamond {
    address immutable IMPL1;
    address immutable IMPL2;

    struct Facet {
        address facetAddress;
        bytes4[] functionSelectors;
    }

    constructor(address impl1, address impl2) {
        IMPL1 = impl1;
        IMPL2 = impl2;
    }

    function facetAddress(bytes4 selector) public view returns (address) {
        if (selector == Add.add.selector) {
            return IMPL1;
        } else if (selector == Multiply.multiply.selector || selector == Multiply.exponent.selector) {
            return IMPL2;
        } else {
            return address(0);
        }
    }

    function facetAddresses() public view returns (address[] memory) {
        address[] memory facetAdds;
        facetAdds[0] = IMPL1;
        facetAdds[1] = IMPL2;

        return facetAdds;
    }

    function facetFunctionSelector(address _facet) public view returns (bytes4[] memory) {
        if (_facet == address(0)) {
            revert("Zero Address");
        }

        if (_facet == IMPL1) {
            bytes4[] memory facetSelectors = new bytes4[](1);

            facetSelectors[0] = Add.add.selector;

            return facetSelectors;
        } else if (_facet == IMPL2) {
            bytes4[] memory facetSelectors = new bytes4[](2);

            facetSelectors[0] = Multiply.multiply.selector;
            facetSelectors[1] = Multiply.exponent.selector;

            return facetSelectors;
        } else {
            bytes4[] memory facetSelectors = new bytes4[](0);

            return facetSelectors;
        }
    }

    function facets() public view returns (Facet[] memory) {
        address[] memory fa = facetAddresses();
        Facet[] memory _facets = new Facet[](2);

        for (uint256 i = 0; i < fa.length; i++) {
            _facets[i].facetAddress = fa[i];
            _facets[i].functionSelectors = facetFunctionSelector(fa[i]);
        }

        return _facets;
    }

    function _fallback() internal {
        address facet = facetAddress(msg.sig);

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
