//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import "../src/Crowdfunding.sol";

contract CrowdfundingTest is Test{
    Crowdfunding campagine;

    address owner = vm.addr(1);
    address donator1 = vm.addr(2);
    address donator2 = vm.addr(3);

    uint256 goal = 100001;
    uint256 duration = 3700;
    string imageUrl = "https://upload.wikimedia.org/wikipedia/commons/b/b6/Image_created_with_a_mobile_phone.png";
    string title = "New Campaigne";
    string description = "bla bla bla";

    function setUp() public {
        vm.startPrank(owner);
        campagine = new Crowdfunding(goal, duration, owner, imageUrl, title, description);
        vm.stopPrank();
    }

    function test_Donate() public {
        uint256 donation = 0.5 ether;

        vm.prank(donator1);
        campagine.donate{value: donation}();
        
    
        assertEq(campagine.totalAmount(), donation);
    }

    function test_DonateShouldRevertsTooLate() public {
        vm.warp(block.timestamp + duration + 1);

        vm.prank(donator1);
        vm.expectRevert(Crowdfunding.TooLate.selector);
        campagine.donate{value: 1 ether}();
    }

    function test_DonateShouldRevertGoalReached() public {
    
        vm.prank(donator1);
        campagine.donate{value: goal}();

    
        assertTrue(campagine.isReached());

        vm.prank(donator2);
        vm.expectRevert(Crowdfunding.GoalReached.selector);
        campagine.donate{value: 1 ether}();
    }

    function test_DonateShouldRevertTooSmallAmount() public {
        vm.prank(donator1);
        vm.expectRevert(Crowdfunding.TooSmallAmount.selector);
        campagine.donate{value: 100 wei}();
    }

}