// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface ERC20 {
    function transfer(address to, uint256 value) external returns (bool);
    function balanceOf(address account) external returns (uint256);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract Faucet {
    address public owner;
    uint256 public tokenAmount1;
    uint256 public tokenAmount2;
    uint256 public waitTime;
    bool public lock; 
    ERC20 public tokenInstance1;
    ERC20 public tokenInstance2;    
    mapping(address => uint256) unlockTime;

    modifier onlyOwner() {
        require(msg.sender==owner, "sender is not a owner");
        _;
    }

    //Events
    event Withdrawal(address indexed to, uint amount);
    event Deposit(address indexed from, uint amount);
    
    constructor(address _tokenInstance1, address _tokenInstance2, uint256 _tokenAmount1, uint256 _tokenAmount2, uint256 _waitTime) {
        require(_tokenInstance1 != address(0));
        require(_tokenInstance2 != address(0));
        tokenInstance1 = ERC20(_tokenInstance1);
        tokenInstance2 = ERC20(_tokenInstance2);
        tokenAmount1 = _tokenAmount1;
        tokenAmount2 = _tokenAmount2;
        waitTime = _waitTime;
        lock = false;
        owner = msg.sender;
    }

    function requestTokens() external {
        //re-entrancy mutex
        require(!lock);
        lock = true;

        //check unlock time
        require(allowedToWithdraw(msg.sender));
        unlockTime[msg.sender] = block.timestamp + waitTime;

        //check faucet balance
        require(tokenInstance1.balanceOf(address(this)) >= tokenAmount1);
        require(tokenInstance2.balanceOf(address(this)) >= tokenAmount2);

        //transfer tokens 
        tokenInstance1.transfer(msg.sender, tokenAmount1);
        tokenInstance2.transfer(msg.sender, tokenAmount2);
        emit Withdrawal(msg.sender,tokenAmount1+tokenAmount2);
        
        //re-entrancy mutex
        lock = false;
    }

    function allowedToWithdraw(address _address) public view returns (bool) {
        if(unlockTime[_address] == 0) {
            return true;
        } else if(block.timestamp >= unlockTime[_address]) {
            return true;
        }
        return false;
    }
    
    function setWaitTime (uint256 _waitTime) external onlyOwner{
        waitTime = _waitTime;
    }
    function setToken1Address(address _token1Address) external onlyOwner {
        require(_token1Address != address(0));
        tokenInstance1 = ERC20(_token1Address);        
    } 

    function setToken2Address(address _token2Address) external onlyOwner {
        require(_token2Address != address(0));        
        tokenInstance2 = ERC20(_token2Address);
    } 

    function setTokenAmount1(uint256 _tokenAmount1) external onlyOwner {
        tokenAmount1 = _tokenAmount1;
    } 

    function setTokenAmount2(uint256 _tokenAmount2) external onlyOwner {
        tokenAmount2 = _tokenAmount2;
    } 

    //  Sending Tokens to this faucet fills it up
    receive() external payable {
        emit Deposit(msg.sender, msg.value); 
    } 
}