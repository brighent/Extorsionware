// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.8;

contract Victim {
    mapping(address => uint) public balances;
    bool reentrancyLock = false;

    modifier reentrancyGuard {
        require(!reentrancyLock);
        reentrancyLock = true;
        _; // This is the execution of the 'modified' function
        reentrancyLock = false;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    /* By adding the modifier 'reentrancyGuard', the function cannot be called multiple time until it finishes */
    function withdraw(uint amount) public reentrancyGuard{ 
       uint bal = balances[msg.sender];
        require(bal > 0,"Not enough balance");
        require(bal >= amount,"Amount higher that total balance");

        (bool sent, ) = msg.sender.call{value: amount}("");

        balances[msg.sender] = 0;
    }
}