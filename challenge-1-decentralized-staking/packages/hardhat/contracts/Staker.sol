// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  mapping ( address => uint256 ) public balances;
  
  uint256 public constant threshold = 10 ether;

  uint256 public balance = 0 ether;

  uint256 public deadline = block.timestamp + 20 seconds;

  bool public openForWithdraw = false;

  constructor(address exampleExternalContractAddress) payable {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  // function deposit(uint256 value) public payable {}

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  // ( Make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
  function stake() public payable{
    if (balances[payable(msg.sender)] != 0) { // need to check if user stake twice
      balances[payable(msg.sender)] += uint256(msg.value);
    } else {
      balances[payable(msg.sender)] = uint256(msg.value); 
    }
  }

  // After some `deadline` allow anyone to call an `execute()` function
  // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()`
  function execute() public {
    if (block.timestamp > deadline) {
      if (address(this).balance >= threshold) {
        exampleExternalContract.complete{value: address(this).balance}();
      } else {
        openForWithdraw = true;
      }
    }
  }

  // If the `threshold` was not met, allow everyone to call a `withdraw()` function to withdraw their balance
  function withdraw() public {

    if (openForWithdraw) {
      if (balances[msg.sender] != 0) {
        payable(msg.sender).transfer(balances[msg.sender]); 
        delete balances[msg.sender];  // need to delete balances so user doesn't withdraw twice 
      } 

    }
  }

  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend
  function timeLeft() public view returns (uint256) {
    if (block.timestamp >= deadline) {
      return 0;
    }
    return deadline - block.timestamp;
  }

  // Add the `receive()` special function that receives eth and calls stake()
  function receive() public {

    stake();
  }
}
