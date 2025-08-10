//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import "../src/CrowdfundingFactory.sol";

contract CrowdfundingFactoryTest is Test{
    CrowdfundingFactory factory;

    address owner = vm.addr(1);
    address owner = vm.addr(2);
    uint256 goal = 100001;
    uint256 duration = 3700;
    string imageUrl = "https://upload.wikimedia.org/wikipedia/commons/b/b6/Image_created_with_a_mobile_phone.png";
    string title = "New Campaigne";
    string description = "bla bla bla";


    function setUp() public {
        vm.prank(owner);
        factory = new CrowdfundingFactory();
    }

    function test_CreateCampaigne() public {
        vm.startPrank(owner);
        factory.createCampaigne(goal, duration, imageUrl , title, description);

        vm.expectEmit(false, false, false, true);
        emit CampaigneCreated(goal, duration, owner, block.timestamp);

        address[] memory campaignes = factory.getAllCampaignes();
        assertEq(campaignes.length, 1);

        address[] memory userCampaignes = factory.userCampaignes();
        assertEq(userCampaignes.legnth, 1);

        vm.stopPrank();
    }

    function test_test_CreateCampaigneRevertsTooSmallGoal(){
        vm.startPrank(owner);

        vm.expectRevert(CrowdfundingFactory.ToSmallGoal.selector);
        factory.createCampaigne(1000, duration, imageUrl , title, description);

        vm.stopPrank();
    }

    function test_test_CreateCampaigneRevertsTooSmallDusration(){
        vm.startPrank(owner);

        vm.expectRevert(CrowdfundingFactory.TooSmallDuration.selector);
        factory.createCampaigne(goal, 3500, imageUrl , title, description);
        
        vm.stopPrank();
    }

    function test_getAllCampaignes() public{
       vm.startPrank(owner);
        factory.createCampaigne(goal, duration, imageUrl , title, description);

        address[] memory campaignes = factory.getAllCampaignes();
        assertEq(campaignes.length, 1);

        factory.createCampaigne(goal, duration, imageUrl , title, description);

        address[] memory campaignes = factory.getAllCampaignes();
        assertEq(campaignes.length, 2);

        vm.stopPrank();
    }

    function getUserCampaignes() public{
        vm.startPrank(owner);
        factory.createCampaigne(goal, duration, imageUrl , title, description);

        address[] memory userCampaignes = factory.userCampaignes();
        assertEq(userCampaignes.legnth, 1);

        factory.createCampaigne(goal, duration, imageUrl , title, description);

        address[] memory userCampaignes = factory.userCampaignes();
        assertEq(userCampaignes.legnth, 2);

        vm.stopPrank();
    }
}