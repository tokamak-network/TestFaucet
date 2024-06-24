// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Faucetv2 {
    using SafeERC20 for IERC20;
    address public owner;
    uint256 public tokenAmount1;
    uint256 public tokenAmount2;
    uint256 public tokenAmount3;
    uint256 public tokenAmount4;
    uint256 public waitTime;
    bool public lock; 
    IERC20 public tokenInstance1;
    IERC20 public tokenInstance2;    
    IERC20 public tokenInstance3;    
    IERC20 public tokenInstance4;    

    mapping(address => uint256) unlockTime;

    modifier onlyOwner() {
        require(msg.sender==owner, "sender is not a owner");
        _;
    }

    //Events
    event Withdrawals(address indexed to, uint amount1, uint amount2, uint amount3, uint amount4);
    event Deposit(address indexed from, uint amount);
    
    constructor(address _tokenInstance1, address _tokenInstance2, address _tokenInstance3, address _tokenInstance4, uint256 _tokenAmount1, uint256 _tokenAmount2, uint256 _tokenAmount3, uint256 _tokenAmount4, uint256 _waitTime) {
        tokenInstance1 = IERC20(_tokenInstance1);
        tokenInstance2 = IERC20(_tokenInstance2);
        tokenInstance3 = IERC20(_tokenInstance3);
        tokenInstance4 = IERC20(_tokenInstance4);

        tokenAmount1 = _tokenAmount1;
        tokenAmount2 = _tokenAmount2;
        tokenAmount3 = _tokenAmount3;
        tokenAmount4 = _tokenAmount4;

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
        require(tokenInstance3.balanceOf(address(this)) >= tokenAmount3);
        require(tokenInstance4.balanceOf(address(this)) >= tokenAmount4);

        //transfer tokens 
        tokenInstance1.safeTransfer(msg.sender, tokenAmount1);
        tokenInstance2.safeTransfer(msg.sender, tokenAmount2);
        tokenInstance3.safeTransfer(msg.sender, tokenAmount3);
        tokenInstance4.safeTransfer(msg.sender, tokenAmount4);
        emit Withdrawals(msg.sender,tokenAmount1,tokenAmount2,tokenAmount3,tokenAmount4);
        
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
    function setToken1Address(address _tokenAddress) external onlyOwner {
        require(_tokenAddress != address(0));        
        tokenInstance1 = IERC20(_tokenAddress);        
    } 

    function setToken2Address(address _tokenAddress) external onlyOwner {
        require(_tokenAddress != address(0));        
        tokenInstance2 = IERC20(_tokenAddress);
    } 
    
    function setToken3Address(address _tokenAddress) external onlyOwner {
        require(_tokenAddress != address(0));        
        tokenInstance3 = IERC20(_tokenAddress);
    } 
    
    function setToken4Address(address _tokenAddress) external onlyOwner {
        require(_tokenAddress != address(0));        
        tokenInstance4 = IERC20(_tokenAddress);
    } 

    function setTokenAmount1(uint256 _tokenAmount) external onlyOwner {
        tokenAmount1 = _tokenAmount;
    } 

    function setTokenAmount2(uint256 _tokenAmount) external onlyOwner {
        tokenAmount2 = _tokenAmount;
    } 
    
    function setTokenAmount3(uint256 _tokenAmount) external onlyOwner {
        tokenAmount3 = _tokenAmount;
    } 
    
    function setTokenAmount4(uint256 _tokenAmount) external onlyOwner {
        tokenAmount4 = _tokenAmount;
    } 


    function withdawAll() external onlyOwner{
        if (address(this).balance > 0){
            (bool callSuccess, ) = owner.call{value: address(this).balance}("");
            require(callSuccess, "Transfer failed");
        }
        if (tokenInstance1.balanceOf(address(this))>0){
            tokenInstance1.safeTransfer(msg.sender, tokenInstance1.balanceOf(address(this)));
        }
        if (tokenInstance2.balanceOf(address(this))>0){
            tokenInstance2.safeTransfer(msg.sender, tokenInstance2.balanceOf(address(this)));
        }
        if (tokenInstance3.balanceOf(address(this))>0){
            tokenInstance3.safeTransfer(msg.sender, tokenInstance3.balanceOf(address(this)));
        }
        if (tokenInstance4.balanceOf(address(this))>0){
            tokenInstance4.safeTransfer(msg.sender, tokenInstance4.balanceOf(address(this)));
        }
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        owner = newOwner;
    }

    //  Sending Tokens to this faucet fills it up
    receive() external payable {
        emit Deposit(msg.sender, msg.value); 
    } 
}