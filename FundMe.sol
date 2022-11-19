//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract FundMe{
    address public owner;

    constructor() public{
        owner = msg.sender;
    }

    mapping(address => uint256) public fundMap;
    //working in gwei coin    
    //function that accepts payment
    //payable: this function pays for things
    function fund() public payable{
        fundMap[msg.sender] += msg.value;
    }

    function getVersion() public view returns(uint256){
        AggregatorV3Interface pricefeed = AggregatorV3Interface(0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612);
        return pricefeed.version();

    }

//returns the conversion price from eth to usd
    function getPrice() public view returns(uint256){
        AggregatorV3Interface pricefeed = AggregatorV3Interface(0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612);
        (,int256 answer,,,) =  pricefeed.latestRoundData();
        return uint256(answer);
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        uint256 ethPrice = getPrice();
        uint256 ethInUSD = (ethPrice * ethAmount) / 1000000000000000000 ;
        return ethInUSD;
    }


    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function withdraw() payable onlyOwner public {
        msg.sender.transfer(address(this).balance);
    }


}