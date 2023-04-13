// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

contract A {
    uint public num;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function setVars(address _contract, uint _num) public payable {
        // A's storage is set, B is not modified.
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setVars(uint256)", _num)
        );
    }

    function important() public {
        require(owner == msg.sender);
        // Delicate stuff...
    }
}

contract B {
    uint public num;
    address public owner;

    function setVars(uint _num) public payable {
        num = _num;
    }
}

contract M {
    // NOTE: storage layout must be the same as contract A
    uint public num;
    address public owner;

    function setVars(uint _num) public payable {
        num = _num;
        owner = msg.sender;
    }
}