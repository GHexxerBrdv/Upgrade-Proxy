// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ImplementationV1 - Dutch Ausction
 * @author Gaurang Bharadava
 * @notice  This dutch auction allows user to sell their goods with desired price, the price will gose down by the time pass by defined discountRate set by seller.
 */
contract ImplementationV1 {
    error DutchAuction__AuctionIsNotActive();
    error DutchAuction__SendEnoughMoney();
    error DutchAuction__GoodIsSold();

    address internal immutable seller;
    string internal description;
    uint256 internal immutable startingPrice;
    uint256 internal immutable discountRate;
    uint256 internal immutable timestamp;
    uint256 internal immutable duration;
    uint256 internal sellerBalance;
    uint256 internal threshold;
    bool internal isActive;
    bool internal isSold;
    bool internal lock;

    modifier auctionStatus() {
        if (isSold) {
            revert DutchAuction__GoodIsSold();
        }

        if (block.timestamp > duration) {
            revert DutchAuction__AuctionIsNotActive();
        }

        if (!isActive) {
            revert DutchAuction__AuctionIsNotActive();
        }
        _;
    }

    modifier locked() {
        require(!lock, "Reentrancy detected");
        lock = true;
        _;
        lock = false;
    }

    constructor(
        address _seller,
        string memory _description,
        uint256 _price,
        uint256 _discountRateInBP,
        uint256 _duration,
        uint256 _threshold
    ) {
        seller = _seller;
        description = _description;
        startingPrice = _price;
        discountRate = (_discountRateInBP * 1e18) / 10000;
        timestamp = block.timestamp;
        duration = timestamp + (_duration * 1 days);
        isActive = true;
        threshold = _threshold;
    }

    function getPrice() public view auctionStatus returns (uint256) {
        uint256 timeElapsed = block.timestamp - timestamp;
        uint256 dayPassed = timeElapsed / 1 days;
        uint256 discount = discountRate * dayPassed;
        if (discount >= startingPrice) {
            return threshold;
        }

        if (startingPrice - discount < threshold) {
            return threshold;
        }
        return startingPrice - discount;
    }

    function buyGood() external payable auctionStatus locked {
        uint256 goodPrice = getPrice();
        if (msg.value < goodPrice) {
            revert DutchAuction__SendEnoughMoney();
        }
        isSold = true;
        sellerBalance = goodPrice;
    }

    function getSeller() external view returns (address) {
        return seller;
    }

    function getDuration() external view returns (uint256) {
        return duration;
    }

    function getDescription() external view returns (string memory) {
        return description;
    }

    function getStartingPrice() external view returns (uint256) {
        return startingPrice;
    }

    function getDiscountRate() external view returns (uint256) {
        return discountRate;
    }

    function getStatus() external view returns (bool, bool) {
        return (isActive, isSold);
    }
}
