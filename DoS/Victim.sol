// INSECURE

// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.8;

contract Auction {
    address payable currentLeader;
    uint public highestBid;

    function bid() payable public {
        if (msg.value <= highestBid) { revert("Current highest bid is higher"); }

        bool status = currentLeader.send(highestBid);
        if (!status) { revert("Could not send ETH back"); } // Refund the old leader, and throw if it fails

        currentLeader = payable(msg.sender);
        highestBid = msg.value;
    }
}
