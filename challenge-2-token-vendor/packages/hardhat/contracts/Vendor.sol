pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

  YourToken public yourToken;

  uint256 public constant tokensPerEth = 100;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function buyTokens() public payable{
    uint256 tokens = msg.value * tokensPerEth;

    yourToken.transfer(msg.sender, tokens);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public {
    address sender = address(msg.sender);
    if (sender == owner()) {
      payable(owner()).transfer(address(this).balance);
    }
  }

  // ToDo: create a sellTokens(uint256 _amount) function:
  function sellTokens(uint256 amount) public {
    yourToken.transferFrom(msg.sender, address(this), amount);
    payable(address(msg.sender)).transfer(amount / tokensPerEth);
  }
}
