// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");

    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 1 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        fundMe = new DeployFundMe().run();
        console.log("OWNER: ", fundMe.i_owner());
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    // In order to check if i_owner is being set to msg.sender:
    // Here since FundMeTest deploys the FundMe contract (in the setUp function),
    // we check i_owner == address(this)
    function testOwnerIsMsgSender() public {
        // In the following line when the owner of the FundMe contract changes according to the way we deploy FundMe contract:
        // 1. If FundMe is deployed using setUp function of FundMetest.t.sol contract, we set:
        // assertEq(fundMe.i_owner(), address(this));
        // 2. If FundMe is deployed from the run function of the DeployFundMe contract, we set:
        // assertEq(fundMe.i_owner(), msg.sender);, because of vm.startBroadcast();
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsAccourate() public {
        console.log(fundMe.getVersion());
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert(); // This expects the next line to revert
        fundMe.fund(); // sending 0 ETH, hence it will revert
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // The next tx will be sent by USER.

        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public funded {
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawFromASingleFunder() public funded {
        // Arrange
        uint256 startingOwnerBalance = fundMe.i_owner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.prank(fundMe.i_owner());
        fundMe.withdraw();

        // Assert
        assertEq(address(fundMe).balance, 0);
        assertEq(
            fundMe.i_owner().balance,
            startingOwnerBalance + startingFundMeBalance
        );
    }

    function testWithdrawFromMultipleFunders() public {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        // Act
        vm.prank(fundMe.i_owner());
        fundMe.withdraw();


        uint256 startingOwnerBalance = fundMe.i_owner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        
        // Assert
        assertEq(address(fundMe).balance, 0);
        assertEq(address(fundMe.i_owner()).balance, startingOwnerBalance + startingFundMeBalance);
    }

    function testCheaperWithdraw() public {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        // Act
        vm.prank(fundMe.i_owner());
        fundMe.cheaperWithdraw();


        uint256 startingOwnerBalance = fundMe.i_owner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        
        // Assert
        assertEq(address(fundMe).balance, 0);
        assertEq(address(fundMe.i_owner()).balance, startingOwnerBalance + startingFundMeBalance);
    }
}
