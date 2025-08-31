/**
 * 1. Deploy mock contracts when we're on a local anvil chain, check getAnvilEthConfig()
 * 2. Keep track of contract addresses across different chains 
*/ 

import {Script, console} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract HelperConfig is Script {

  NetworkConfig public activeNetworkConfig;
  uint8 public constant DECIMALS = 8;
  int256 public constant INITIAL_PRICE = 3000e8;

  struct NetworkConfig {
    address priceFeed;
  }

  constructor () {
    if (block.chainid == 11155111) {
      activeNetworkConfig = getSepoliaEthConfig();
    }else if (block.chainid == 1) {
      activeNetworkConfig = getMainnetEthConfig();
    } else {
      activeNetworkConfig = getAnvilEthConfig();
    }
  }
  // If we're on local anvil node, we deploy mocks
  // Else, we grab the existing Chainlink contracts deployed on the network.abi
  function getSepoliaEthConfig() public pure returns (NetworkConfig memory){
    NetworkConfig memory sepoliaConfig = NetworkConfig(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    return sepoliaConfig;
  }

  function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
    NetworkConfig memory mainnetConfig = NetworkConfig(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
    return mainnetConfig;
  }

  function getAnvilEthConfig() public returns (NetworkConfig memory) {
    if (activeNetworkConfig.priceFeed != address(0)) {
      console.log('In if of getAnvilEthConfig()');
      return activeNetworkConfig;
    }
    // 1. Deploy the Mock Contracts
    // 2. Return the mock addresses
    
    // #1
    vm.startBroadcast();
    MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
    vm.stopBroadcast();

    // #2
    NetworkConfig memory anvilConfig = NetworkConfig(address(mockPriceFeed));
    return anvilConfig;
  }
}