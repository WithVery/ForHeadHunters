// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Greeter {
    address private _owner;
    string private greeting;
    address private greeter;

    constructor(string memory _greeting) payable {
      _owner = msg.sender;
      greeter = msg.sender;
      greeting = _greeting;
    }

    function greetMe(string calldata _greeting) public {
      greeter = msg.sender;
      greeting = _greeting;
    }

    function getGreeting() public view returns(string memory) {
      return greeting;
    }

    function owner() public view returns (address) {
      return _owner;
    }

    function lastGreeter() public view returns (address) {
      return greeter;
    }

}
