// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDiamondCut} from "./interfaces/IDiamondCut.sol";
import {LibDiamond} from "../DiamondProxy/library/LibDiamond.sol";

contract Diamondcut is IDiamondCut {
    function diamondCut(FacetCut[] calldata _diamondCut, address _init, bytes calldata _calldata) external {
        LibDiamond.enforceIsContactOwner();
        LibDiamond.diamondCut(_diamondCut, _init, _calldata);
    }
}
