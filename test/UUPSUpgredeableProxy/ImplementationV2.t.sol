// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {ImplementationV2} from "../../src/UUPSUpgredeableProxy/ImplementationV2.sol";

contract ImplementationV2Test is Test {
    ImplementationV2 auction;
    address seller = makeAddr("seller");
    user hacker;

    function setUp() public {
        auction = new ImplementationV2(seller, "Buy Hoodie", 1 ether, 20, 7, 0.5 ether);
        hacker = new user();
    }

    function test_construction() public view {
        console2.log("address of the auction is:", address(auction));
        assertEq(auction.getSeller(), seller);
        assertEq(auction.getDescription(), "Buy Hoodie");
        console2.log("the starting price of auction is:", auction.getStartingPrice());
        assertEq(auction.getDuration(), auction.getTimestamp() + 7 days);
    }

    function test_getPrice() public {
        uint256 priceBefore = auction.getPrice();
        console2.log("Price before: ", priceBefore);
        vm.warp(auction.getTimestamp() + 5 days);

        uint256 priceAfter = auction.getPrice();
        console2.log("Price after: ", priceAfter);

        assertGt(priceBefore, priceAfter);
    }

    function test_buyGoods() public {
        address buyer = makeAddr("buyer");
        vm.deal(buyer, 1 ether);
        vm.warp(auction.getTimestamp() + 6 days);
        vm.startPrank(buyer);
        auction.buyGood{value: 1 ether}();

        console2.log(auction.getSellerBalance());
        vm.expectRevert();
        auction.getPrice();
        console2.log("balance of buyer", buyer.balance);
        (, bool isSold) = auction.getStatus();
        assertTrue(isSold);
        vm.stopPrank();
    }

    function test_CanNotBuyGoodAfterSold() public {
        address buyer = makeAddr("buyer");
        vm.deal(buyer, 1 ether);
        vm.warp(auction.getTimestamp() + 6 days);
        vm.startPrank(buyer);
        auction.buyGood{value: 1 ether}();
        vm.stopPrank();

        address buyer2 = makeAddr("buyer2");
        vm.deal(buyer2, 1 ether);
        vm.prank(buyer2);
        vm.expectRevert();
        auction.buyGood{value: 1 ether}();
    }

    function test_CanNotBuyWithWrongAmountPrice() public {
        address buyer = makeAddr("buyer");
        vm.deal(buyer, 1 ether);
        vm.warp(auction.getTimestamp() + 6 days);
        vm.startPrank(buyer);
        vm.expectRevert();
        auction.buyGood{value: 0.5 ether}();
        vm.stopPrank();
    }

    function test_CanNotBuyAfterDuration() public {
        address buyer = makeAddr("buyer");
        vm.deal(buyer, 1 ether);
        vm.warp(auction.getTimestamp() + 7 days + 1);
        vm.startPrank(buyer);
        vm.expectRevert();
        auction.buyGood{value: 1 ether}();
        vm.stopPrank();
    }

    function test_UpdateSellerBalance() public {
        address buyer = makeAddr("buyer");
        vm.deal(buyer, 1 ether);
        vm.warp(auction.getTimestamp() + 6 days);
        vm.startPrank(buyer);
        auction.buyGood{value: 1 ether}();
        vm.stopPrank();

        assertGt(auction.getSellerBalance(), 0);
    }

    function test_OnlySellerCanWithdraw() public {
        address buyer = makeAddr("buyer");
        vm.deal(buyer, 1 ether);
        vm.warp(auction.getTimestamp() + 6 days);
        vm.startPrank(buyer);
        auction.buyGood{value: 1 ether}();
        vm.stopPrank();

        assertGt(auction.getSellerBalance(), 0);

        vm.prank(buyer);
        vm.expectRevert();
        auction.withdraw();
    }

    function test_Afterwithdraw() public {
        address buyer = makeAddr("buyer");
        vm.deal(buyer, 1 ether);
        vm.warp(auction.getTimestamp() + 6 days);
        vm.startPrank(buyer);
        auction.buyGood{value: 1 ether}();
        vm.stopPrank();

        assertGt(auction.getSellerBalance(), 0);

        vm.prank(seller);
        auction.withdraw();

        assertEq(auction.getSellerBalance(), 0);
        console2.log("The balance of seller: ", seller.balance);
    }

    function test_getPriceAfterDeadline() public {
        vm.warp(auction.getTimestamp() + 7 days + 1);
        vm.expectRevert();
        auction.getPrice();
    }
}

contract user {
    constructor() {}

    fallback() external payable {
        revert();
    }
}
