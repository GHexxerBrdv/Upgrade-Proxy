// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IDamond} from "./IDiamond.sol";

interface IDiamodCut is IDamond {
    function diamondCut(FacetCut[] calldata _diamondCut, address _init, bytes calldata _calldata) external;
}
