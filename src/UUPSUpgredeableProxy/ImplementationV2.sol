// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ImplementationV1} from "./ImplementationV1.sol";

contract ImplementationV2 is ImplementationV1 {
    error DutchAuction__TransactionFailed();
    error DutchAuction__CallerIsNotSeller();

    constructor(
        address _seller,
        string memory _description,
        uint256 _price,
        uint256 _discountRateInBP,
        uint256 _duration,
        uint256 _threshold
    ) ImplementationV1(_seller, _description, _price, _discountRateInBP, _duration, _threshold) {}

    function withdraw() external {
        if (msg.sender != seller) {
            revert DutchAuction__CallerIsNotSeller();
        }
        uint256 balance = sellerBalance;
        sellerBalance = 0;
        isActive = false;
        (bool ok,) = payable(seller).call{value: balance}("");

        if (!ok) {
            revert DutchAuction__TransactionFailed();
        }
    }
}
