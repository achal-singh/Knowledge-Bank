// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// 0x694AA1769357215DE4FAC081bf1f309aDC325306 is deployed on Ethereum Sepolia for ETH-USD pair.
library PriceConverter {
    function getPrice() internal view returns (uint256) {
        (, int256 answer, , , ) = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        ).latestRoundData();
        return uint256(answer * 1e10);
    }
    function getConversionRate(
        uint256 ethAmount
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice();
        return (ethPrice * ethAmount) / 1e18;
    }
}
