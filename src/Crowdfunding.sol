//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Crowdfunding is ReentrancyGuard{
    uint256 public goal;
    address public owner;
    string public imageUrl;
    string public title;
    uint256 public deadline;
    uint256 public totalAmount;
    string public description;
    bool public isReached;

    mapping(address => uint256) donators;

    error TooLate();
    error GoalReached();
    error NotAnOwner();
    error TooSmallAmount();

    event Donate(address sender, uint256 amount, uint256 timestamp);
    event FundsWithdrawn(address owner, uint256 amount, uint256 timestamp);

    constructor(uint256 _goal, uint256 _duration, address _creator, string memory _imageUrl, string memory _title, string memory _description){
        owner = _creator;
        deadline = block.timestamp + _duration;
        imageUrl = _imageUrl;
        title = _title;
        description = _description;
        goal = _goal;
    }

    function donate() public payable {
        if(block.timestamp > deadline){
            revert TooLate();
        }

        if(isReached == true){
            revert GoalReached();
        }

        if(msg.value <= 1000){
            revert TooSmallAmount();
        }

        if(msg.value + totalAmount >= goal){
            isReached = true;
        }

        emit Donate(msg.sender, msg.value, block.timestamp);

        donators[msg.sender] += msg.value;

        totalAmount += msg.value;
    }

    function withdraw() payable public nonReentrant{
        if(msg.sender != owner){
            revert NotAnOwner();
        }
        if(isReached == true || block.timestamp > deadline) {
            payable(owner).transfer(address(this).balance);
        }

        emit FundsWithdrawn(msg.sender, address(this).balance, block.timestamp);
        totalAmount = 0;
    }

}