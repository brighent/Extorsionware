// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

contract Defenceful{ 
    mapping(address => bool) public allowed;
    address owner;

    constructor() {
        owner = msg.sender;
        allowed[owner] = true;
    }

    function interact() public payable {
        require(allowed[msg.sender], "Account not allowed");
        // Do stuff...
    }

    function insert_address(address _a) public{ 
        require(msg.sender == owner);
        allowed[_a] = true;        
    }

    function delete_address(address _a) public {
        require(msg.sender == owner);
        allowed[_a] = false;
    }
}