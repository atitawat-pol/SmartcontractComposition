pragma solidity ^0.6.0;

interface CEtherInterface {
    // Compound totalSupply interface
    function totalSupply() external view returns (uint);
    function mint() external payable;
    function balanceOf(address owner) external view returns (uint256 balance);
    function transfer(address dst, uint256 amount) external nonReentrant returns (bool);
}

contract CompoundWallet {
    address public cEtherAddress = 0x41B5844f4680a8C38fBb695b7F9CFd1F64474a72;

    function readTotalSupply() public view returns (uint256) {
        CEtherInterface cEther = CEtherInterface(cEtherAddress);
        return cEther.totalSupply();
    }

    function deposit() public payable {
        CEtherInterface cEther = CEtherInterface(cEtherAddress);
        cEther.mint.value(msg.value)(); // deposit ETH and send back cETH
    }

    function withdraw() public {
        CEtherInterface cEther = CEtherInterface(cEtherAddress);
        uint256 balance = cEther.balanceOf(address(this));
        cEther.transfer(msg.sender, balance);
    }

    modifier nonReentrant() {
        require(_notEntered, "re-entered");
        _notEntered = false;
        _;
        _notEntered = true; // get a gas-refund post-Istanbul
    }
}