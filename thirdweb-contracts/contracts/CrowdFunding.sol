// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Declares the start of a new smart contract named "CrowdFunding".
contract CrowdFunding {

    // Declare a struct named "Campaign" with various fields to store information about a campaign, such as:
    // the owner's address, title, description, target, deadline, amount collected, image, and arrays for the donators and donations.
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    // Declare a mapping that is used to store all of the campaigns that have been created. 
    // The key of the mapping is a uint256 and the value is a Campaign. 
    // The "public" keyword means that the mapping is accessible from outside of the smart contract.
    mapping(uint256 => Campaign) public campaigns;

    // Declare a variable named "numberOfCampaigns" of type uint256 and initialize to 0. 
    // It is also declared public so that it can be accessed from outside of the contract.
    uint256 public numberOfCampaigns = 0;

    // Declare a function named "createCampaign" that takes multiple input arguments. 
    // The function creates a new campaign and assigns the inputs to the corresponding fields of the Campaign struct. 
    function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns (uint256) {
        
        // The "storage" keyword means that the variable "campaign" will have a long-term storage within the smart contract.
        Campaign storage campaign = campaigns[numberOfCampaigns];

        // This line checks if the deadline is a date in the future. If it's not, the function will return an error message.
        require(campaign.deadline < block.timestamp, "The deadline should be a date in the future.");

        // These lines assigns the input arguments to the corresponding fields of the Campaign struct.
        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        // This line increments the number of campaigns by 1.
        numberOfCampaigns++;

        // This line returns the index of the newly created campaign and function ends here.
        return numberOfCampaigns - 1;
    }

    // Declare a function named "donateToCampaign" that takes an input argument of type uint256 named "_id" which is the id of the campaign to donate. 
    // The "public" and "payable" keywords specify that the function can be called from external contracts and that it can accept ether as a form of payment.
    function donateToCampaign(uint256 _id) public payable {
        // Declare a variable named "amount" of type uint256 and assigns it the value of the amount of ether sent in the transaction. 
        // "msg.value" is a built-in variable in Solidity that holds the value of ether sent in the transaction.
        uint256 amount = msg.value;

        // This line retrieves the campaign struct corresponding to the id provided as input and assigns it to a variable named "campaign".
        Campaign storage campaign = campaigns[_id];

        // These lines push the address of the user who made the donation (msg.sender) and the amount of the donation to the corresponding arrays of the campaign struct.
        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

         // This line sends the ether to the owner of the campaign, and returns a boolean value indicating whether the transfer was successful.
        (bool sent, ) = payable(campaign.owner).call{ value: amount }("");

        // If the transfer was successful, this line adds the amount of the donation to the campaign's amountCollected field.
        if(sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }
    
    // Declare a function named "getDonators" that takes an input argument of type uint256 named "_id" which is the id of the campaign to get the donators. 
    // The "view" keyword specifies that the function will not change the state of the contract. 
    // The "public" keyword means that the function can be called from external contracts. 
    // The function returns two arrays, one of type address[] memory and another of type uint256[] memory, which are the donators and donations.
    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory) {
        // This line returns the donators and donations arrays of the campaign struct corresponding to the id provided as input, using destructuring assignment.
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    // Declares a function named "getCampaigns" that does not take any input argument. 
    // The "view" keyword specifies that the function will not change the state of the contract and the "public" keyword means that the function can be called from external contracts. 
    // The function returns an array of type Campaign[] memory.
    function getCampaigns() view public returns (Campaign[] memory) {
        // This line declares an empty array of Campaign structs named "allCampaigns" with length of numberOfCampaigns.
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        // This loop iterates through all the campaigns in the mapping and assigns each campaign struct to the corresponding index in the "allCampaigns" array.
        for(uint i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];
            allCampaigns[i] = item;
        }

         // This line returns the allCampaigns array, containing all the campaigns.
        return allCampaigns;
    }
}