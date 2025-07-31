//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./Crowdfunding.sol";

contract CrowdfundingFactory {
    address[] public campaignes;

    error TooSmallDuration();
    error ToSmallGoal();

    mapping(address => address[]) public userCampaignes;

    event CampaigneCreated(uint256 goal, uint256 duration, address creator, uint256 timestamp);

    /// @notice Creates a new crowdfunding campaign
    /// @param _goal The funding goal in wei (minimum 100,000 wei)
    /// @param _duration The campaign duration in seconds (minimum 3,600 seconds)
    /// @param _imageUrl URL of the campaign image
    /// @param _title Title of the campaign
    /// @param _description Description of the campaign
    function createCampaigne(
        uint256 _goal,
        uint256 _duration,
        string memory _imageUrl,
        string memory _title,
        string memory _description
    ) external {
        if(_goal < 100000) {
            revert ToSmallGoal();
        }
        if(_duration < 3600) {
            revert TooSmallDuration();
        }
        Crowdfunding campaigne = new Crowdfunding(_goal, _duration, msg.sender, _imageUrl, _title, _description);
        campaignes.push(address(campaigne));
        userCampaignes[msg.sender].push(address(campaigne));
        emit CampaigneCreated(_goal, _duration, msg.sender, block.timestamp);
    }

    function getAllCampaignes() public view returns(address[] memory){
        return campaignes;
    }

    function getUserCampaignes(address _creator) public view returns(address[] memory){
        return userCampaignes[_creator];
    }
}