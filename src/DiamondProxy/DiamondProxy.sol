// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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
        return address(1);
    }

    function facetAddresses() external view returns (address[] memory) {}

    function facetFunctionSelector() external view returns (bytes4[] memory) {}

    function facets() external view returns (Facet[] memory) {}

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
