// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {PriceConverter} from "./PriceConverter.sol";

error NotOwner();

contract FundMe {
    address[] public funders;
    using PriceConverter for uint256;
    address public immutable i_owner;
    uint256 public constant MIN_USD = 50 * 1e18;

    mapping(address => uint256) public addressToAmountFunded;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate() > MIN_USD,
            "Minimum deposit amount should be > 5 USD"
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] =
            addressToAmountFunded[msg.sender] +
            msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint i = 0; i < funders.length; i++) {
            addressToAmountFunded[funders[i]] = 0;
        }
        funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "call failed");
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, NotOwner());
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
